import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Apply for a job
  Future<void> applyForJob({
    required String jobId,
    required String companyId,
    String? coverLetter,
    List<String>? attachments,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final application = {
      'jobId': jobId,
      'jobseekerId': userId,
      'companyId': companyId,
      'status': 'pending',
      'appliedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (coverLetter != null) 'coverLetter': coverLetter,
      if (attachments != null) 'attachments': attachments,
    };

    // Start a batch write
    final batch = _firestore.batch();

    // Create the application
    final applicationRef = _firestore.collection('applications').doc();
    batch.set(applicationRef, application);

    // Increment the applications counter on the job
    final jobRef = _firestore.collection('jobs').doc(jobId);
    batch.update(jobRef, {
      'applicationsCount': FieldValue.increment(1),
    });

    // Commit the batch
    await batch.commit();
  }

  // Get applications for a jobseeker
  Stream<QuerySnapshot> getJobseekerApplications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('applications')
        .where('jobseekerId', isEqualTo: userId)
        .orderBy('appliedAt', descending: true)
        .snapshots();
  }

  // Get applications for a company's job
  Stream<QuerySnapshot> getJobApplications(String jobId) {
    return _firestore
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .orderBy('appliedAt', descending: true)
        .snapshots();
  }

  // Update application status (for companies)
  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _firestore.collection('applications').doc(applicationId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Check if user has already applied
  Future<bool> hasApplied(String jobId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final snapshot = await _firestore
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .where('jobseekerId', isEqualTo: userId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Delete all applications (superadmin only)
  Future<void> deleteAllApplications() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check if user is superadmin
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userRole = userDoc.data()?['role'] as String?;
    
    if (userRole != 'superadmin') {
      throw Exception('Unauthorized: Only superadmin can perform this action');
    }

    try {
      // Get all applications
      final QuerySnapshot applications = await _firestore.collection('applications').get();
      
      // Delete each application
      for (var doc in applications.docs) {
        await doc.reference.delete();
        print('Deleted application ${doc.id}');
      }
      
      // Get all jobs to reset their applicationsCount
      final QuerySnapshot jobs = await _firestore.collection('jobs').get();
      
      // Reset applications count and clear applications map for each job
      for (var doc in jobs.docs) {
        await doc.reference.update({
          'applicationsCount': 0,
          'applications': {},
        });
        print('Reset applications for job ${doc.id}');
      }
      
      // Get all users to reset their applicationCount
      final QuerySnapshot users = await _firestore.collection('users').get();
      
      // Reset application count for each user
      for (var doc in users.docs) {
        await doc.reference.update({
          'applicationCount': 0,
        });
        print('Reset application count for user ${doc.id}');
      }
      
      print('Successfully deleted all applications data');
    } catch (e) {
      print('Error deleting applications: $e');
      throw Exception('Failed to delete applications: $e');
    }
  }
} 