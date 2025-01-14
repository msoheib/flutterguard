import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_profile.dart';
import '../models/job_post.dart';
import 'dart:math';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Job Profile CRUD operations
  Future<void> createJobProfile(JobProfile profile) async {
    await _firestore.collection('job_profiles').add(profile.toMap());
  }

  Future<JobProfile?> getJobProfile(String userId) async {
    final doc = await _firestore.collection('job_profiles').doc(userId).get();
    return doc.exists ? JobProfile.fromFirestore(doc) : null;
  }

  Future<void> updateJobProfile(JobProfile profile) async {
    await _firestore.collection('job_profiles').doc(profile.id).update(profile.toMap());
  }

  Future<void> deleteJobProfile(String profileId) async {
    await _firestore.collection('job_profiles').doc(profileId).delete();
  }

  // Job Post CRUD operations
  String generateJobId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'JOB$timestamp$random';
  }

  Future<String> createJob(JobPost job) async {
    final jobId = generateJobId();
    
    // Start a batch write
    final batch = _firestore.batch();
    
    // Create the job document
    final jobRef = _firestore.collection('jobs').doc(jobId);
    batch.set(jobRef, {
      ...job.toFirestore(),
      'id': jobId,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Commit the batch
    await batch.commit();
    return jobId;
  }

  Future<JobPost?> getJobPost(String postId) async {
    final doc = await _firestore.collection('job_posts').doc(postId).get();
    return doc.exists ? JobPost.fromFirestore(doc) : null;
  }

  Future<void> updateJobPost(JobPost post) async {
    await _firestore.collection('job_posts').doc(post.id).update(post.toMap());
  }

  Future<void> deleteJobPost(String postId) async {
    await _firestore.collection('job_posts').doc(postId).delete();
  }

  // Additional methods
  Stream<List<JobPost>> getJobPosts({Map<String, dynamic>? filters}) async* {
    print('Getting job posts with filters: $filters');
    
    try {
      var query = _firestore.collection('jobs')
          .where('status', isEqualTo: 'active');

      if (filters != null) {
        // Get all jobs and filter in memory for both salary and location
        yield* query.snapshots().map((snapshot) {
          var jobs = snapshot.docs.map((doc) => JobPost.fromFirestore(doc)).toList();
          
          // Apply salary filter
          final salaryMin = filters['salaryMin'];
          final salaryMax = filters['salaryMax'];
          if (salaryMin != null || salaryMax != null) {
            jobs = jobs.where((job) {
              // Debug log
              print('Job salary data: ${job.salary}');
              
              final amount = job.salary['amount'];
              if (amount == null) return false;
              
              final jobSalary = double.tryParse(amount.toString()) ?? 0;
              final min = salaryMin?.toDouble() ?? 0;
              final max = salaryMax?.toDouble() ?? double.infinity;
              return jobSalary >= min && jobSalary <= max;
            }).toList();
          }

          // Apply location filter
          final location = filters['location'];
          if (location != null && location.toString().isNotEmpty) {
            jobs = jobs.where((job) {
              final jobLocation = job.location;
              // Debug log
              print('Job location data: $jobLocation');
              
              if (jobLocation is String) {
                return jobLocation == location;
              } else {
                Map<String, dynamic> locationMap = Map<String, dynamic>.from(location);
                return locationMap['city'] == location || locationMap['address'] == location;
              }
            }).toList();
          }
          
          print('Found ${jobs.length} jobs after all filtering');
          return jobs;
        });
      } else {
        // If no filters, return all active jobs
        yield* query.snapshots().map((snapshot) => 
          snapshot.docs.map((doc) => JobPost.fromFirestore(doc)).toList()
        );
      }
    } catch (e, stackTrace) {
      print('Error in getJobPosts: $e');
      print('Stack trace: $stackTrace');
      yield [];
    }
  }

  Stream<List<JobProfile>> getJobProfiles() {
    return _firestore.collection('job_profiles')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => JobProfile.fromFirestore(doc)).toList());
  }

  Future<List<Map<String, String>>> getJobs() async {
    final snapshot = await _firestore.collection('jobs').get();
    return snapshot.docs.map((doc) => {
      'jobTitle': doc['title'] as String,
      'companyName': doc['company'] as String,
      'location': doc['location'] as String,
      'salary': doc['salary']['min'].toString(),
      'jobType': doc['type'] as String,
    }).toList();
  }

  // Remove this method as it's now handled in JobApplicationService
  Future<void> applyForJob(String jobId, String userId, String coverLetter) {
    throw UnimplementedError('Use JobApplicationService.applyForJob() instead');
  }

  Stream<QuerySnapshot> getJobPostings() {
    return _firestore
        .collection('job_postings')
        .where('status', isEqualTo: 'active')
        .orderBy('postedDate', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getJobPosting(String id) {
    return _firestore.collection('job_postings').doc(id).get();
  }

  Stream<List<JobPost>> getFavoriteJobs() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .asyncMap((snapshot) async {
          final favoriteJobIds = snapshot.docs.map((doc) => doc.id).toList();
          if (favoriteJobIds.isEmpty) {
            return [];
          }

          // Fetch all favorite jobs
          final jobDocs = await Future.wait(
            favoriteJobIds.map((jobId) => 
              _firestore.collection('jobs').doc(jobId).get()
            )
          );

          // Filter out any non-existent jobs and convert to JobPost objects
          return jobDocs
              .where((doc) => doc.exists)
              .map((doc) => JobPost.fromFirestore(doc))
              .toList();
        });
  }

  // Add a method to toggle favorite status
  Future<void> toggleFavoriteJob(String jobId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final favoriteRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(jobId);

    final doc = await favoriteRef.get();
    if (doc.exists) {
      await favoriteRef.delete();
    } else {
      await favoriteRef.set({
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Add a method to check if a job is favorited
  Stream<bool> isJobFavorited(String jobId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(false);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(jobId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // Add this method to JobService
  Stream<JobPost?> getJobStream(String jobId) {
    return _firestore
        .collection('jobs')
        .doc(jobId)
        .snapshots()
        .map((doc) => doc.exists ? JobPost.fromFirestore(doc) : null);
  }

  // Get active jobs count for company
  Stream<int> getActiveJobsCount() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(0);

    // For company users, only show their jobs
    return _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'active')
        .where('companyId', isEqualTo: user.uid) // Filter by company
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // When updating job status
  Future<void> updateJobStatus(String jobId, String status) async {
    await _firestore.collection('jobs').doc(jobId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get total applicants count for company
  Stream<int> getTotalApplicantsCount() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(0);

    return _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'active')
        .where('companyId', isEqualTo: user.uid) // Filter by company
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.fold<int>(
            0,
            (sum, doc) => sum + (doc.data()['applicationsCount'] as int? ?? 0)
          );
        });
  }
}
