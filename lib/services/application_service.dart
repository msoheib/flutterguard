import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/application.dart';
import '../models/job_post.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> applyForJob({
    required String jobId,
    required String companyId,
    String? coverLetter,
    List<String>? attachments,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (!jobDoc.exists) throw Exception('Job not found');
      
      final jobData = jobDoc.data()!;
      
      // Handle location map
      Map<String, dynamic> locationMap;
      if (jobData['location'] is String) {
        locationMap = {
          'city': jobData['location'],
          'address': jobData['location']
        };
      } else {
        locationMap = Map<String, dynamic>.from(jobData['location'] ?? {});
      }

      // Handle salary map
      Map<String, dynamic> salaryMap;
      if (jobData['salary'] is num) {
        salaryMap = {
          'amount': jobData['salary'],
          'currency': 'SAR'
        };
      } else {
        salaryMap = Map<String, dynamic>.from(jobData['salary'] ?? {});
      }

      final application = Application(
        id: '',
        userId: user.uid,
        jobId: jobId,
        companyId: companyId,
        status: Application.STATUS_PENDING,
        appliedDate: DateTime.now(),
        updatedAt: DateTime.now(),
        jobTitle: jobData['title'] ?? '',
        companyName: jobData['companyName'] ?? '',
        location: jobData['location'] ?? '',
        locationMap: locationMap,
        salary: (jobData['salary'] ?? 0).toDouble(),
        salaryMap: salaryMap,
        jobType: jobData['type'] ?? '',
        workType: jobData['workType'] ?? '',
        jobSeekerName: user.displayName ?? '',
        coverLetter: coverLetter,
        attachments: attachments,
      );

      await _firestore.collection('applications').add(application.toMap());
    } catch (e) {
      print('Error in applyForJob: $e');
      rethrow;
    }
  }

  Future<bool> hasApplied(String jobId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final snapshot = await _firestore
        .collection('applications')
        .where('jobId', isEqualTo: jobId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
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

  Future<void> deleteAllApplications() async {
    try {
      final applications = await _firestore.collection('applications').get();
      final batch = _firestore.batch();
      
      for (var doc in applications.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      print('Error deleting applications: $e');
      rethrow;
    }
  }

  Future<void> createApplication(JobPost job) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final application = Application(
      id: '',  // Will be set by Firestore
      userId: user.uid,
      jobId: job.id,
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
      jobSeekerName: user.displayName ?? '',
    );

    await _firestore.collection('applications').add(application.toMap());
  }
} 