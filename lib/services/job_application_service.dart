import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/application.dart';
import '../models/job_post.dart';

class JobApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> applyForJob(JobPost job, String jobSeekerName) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check if user has already applied
    final existingApplication = await _firestore
        .collection('applications')
        .where('jobId', isEqualTo: job.id)
        .where('userId', isEqualTo: userId)
        .get();

    if (existingApplication.docs.isNotEmpty) {
      throw Exception('You have already applied for this job');
    }

    final batch = _firestore.batch();
    final applicationRef = _firestore.collection('applications').doc();

    final application = Application(
      id: applicationRef.id,
      jobId: job.id,
      userId: userId,
      companyId: job.companyId,
      status: Application.STATUS_PENDING,
      appliedDate: DateTime.now(),
      updatedAt: DateTime.now(),
      jobTitle: job.title,
      companyName: job.companyName,
      location: job.location['city'] ?? '',
      locationMap: job.location,
      salary: (job.salary['amount'] ?? 0).toDouble(),
      salaryMap: job.salary,
      jobType: job.type,
      workType: job.workType,
      jobSeekerName: jobSeekerName,
    );

    batch.set(applicationRef, application.toMap());

    // Update job document
    final jobRef = _firestore.collection('jobs').doc(job.id);
    batch.update(jobRef, {
      'totalApplications': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Update user's application count
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'applicationCount': FieldValue.increment(1),
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Stream<List<Application>> getUserApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .orderBy('appliedDate', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Application.fromFirestore(doc)).toList());
  }

  Future<bool> hasApplied(String jobId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    final snapshot = await _firestore
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }
} 