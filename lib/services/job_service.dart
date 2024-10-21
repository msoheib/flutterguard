import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_profile.dart';
import '../models/job_post.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<String> createJobPost(JobPost post) async {
    final docRef = await _firestore.collection('job_posts').add(post.toMap());
    return docRef.id;
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
  Stream<List<JobPost>> getJobPosts() {
    return _firestore.collection('job_posts')
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => JobPost.fromFirestore(doc)).toList());
  }

  Stream<List<JobProfile>> getJobProfiles() {
    return _firestore.collection('job_profiles')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => JobProfile.fromFirestore(doc)).toList());
  }
}
