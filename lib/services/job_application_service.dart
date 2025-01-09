import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_application.dart';
import '../models/job_post.dart';

class JobApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get applications for the current user (job seeker)
  Future<List<JobApplication>> getUserApplications() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .orderBy('appliedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => JobApplication.fromFirestore(doc)).toList();
  }

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
        .where('jobId', isEqualTo: job.id ?? '')
        .where('userId', isEqualTo: userId)
        .get();

    if (existingApplication.docs.isNotEmpty) {
      throw Exception('You have already applied for this job');
    }

    // Create new application
    final application = JobApplication(
      id: '', // Will be set by Firestore
      userId: userId,
      status: JobApplication.STATUS_PENDING,
      appliedAt: DateTime.now(),
      coverLetter: null,
      attachments: null,
      jobId: job.id,
      jobTitle: job.title,
      companyId: job.companyId,
      companyName: job.companyName,
    );

    // First create the application document
    final applicationRef = await _firestore.collection('applications').add(application.toMap());

    // Update job applications count and add application to job's applications map
    await _firestore.collection('jobs').doc(job.id).update({
      'applicationsCount': FieldValue.increment(1),
      'applications.${applicationRef.id}': application.toMap(),
    });
  }

  // Update application status (for companies)
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('applications').doc(applicationId).update({
      'status': status,
      'reviewedAt': FieldValue.serverTimestamp(),
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