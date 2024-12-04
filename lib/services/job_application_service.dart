import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_application.dart';
import '../models/job_post.dart';

class JobApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get recent applications for a company
  Stream<List<JobApplication>> getCompanyApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('applications')
        .where('companyId', isEqualTo: userId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobApplication.fromFirestore(doc)).toList());
  }

  // Get applications for a specific job
  Stream<List<JobApplication>> getJobApplications(String jobId) {
    return _firestore
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobApplication.fromFirestore(doc)).toList());
  }

  // Apply for a job (for job seekers)
  Future<void> applyForJob(JobPost job, String jobSeekerName) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check if user has already applied
    final existingApplication = await _firestore
        .collection('applications')
        .where('jobId', isEqualTo: job.id)
        .where('jobSeekerId', isEqualTo: userId)
        .get();

    if (existingApplication.docs.isNotEmpty) {
      throw Exception('You have already applied for this job');
    }

    // Create new application
    final application = JobApplication(
      id: '', // Will be set by Firestore
      jobId: job.id,
      jobSeekerId: userId,
      jobSeekerName: jobSeekerName,
      jobTitle: job.title,
      status: 'pending',
      appliedAt: DateTime.now(),
    );

    await _firestore.collection('applications').add(application.toMap());

    // Update job applications count
    await _firestore.collection('jobs').doc(job.id).update({
      'applicationsCount': FieldValue.increment(1),
    });
  }

  // Update application status (for companies)
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('applications').doc(applicationId).update({
      'status': status,
    });
  }

  // Mark application as read (for companies)
  Future<void> markAsRead(String applicationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('applications').doc(applicationId).update({
      'isRead': true,
    });
  }

  // Get unread applications count (for companies)
  Stream<int> getUnreadApplicationsCount() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(0);

    return _firestore
        .collection('applications')
        .where('companyId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
} 