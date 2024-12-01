import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/company.dart';
import '../models/job_post.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get company profile
  Stream<Company?> getCompanyProfile() {
    return _firestore
        .collection('companies')
        .doc(_auth.currentUser?.uid)
        .snapshots()
        .map((doc) => doc.exists ? Company.fromFirestore(doc) : null);
  }

  // Create or update company profile
  Future<void> updateCompanyProfile(Company company) async {
    await _firestore
        .collection('companies')
        .doc(_auth.currentUser?.uid)
        .set(company.toFirestore(), SetOptions(merge: true));
  }

  // Post a new job
  Future<String> postJob(JobPost job) async {
    // Create the job document
    DocumentReference jobRef = await _firestore.collection('jobs').add(job.toFirestore());

    // Update company's posted jobs list
    await _firestore.collection('companies').doc(_auth.currentUser?.uid).update({
      'postedJobs': FieldValue.arrayUnion([jobRef.id]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return jobRef.id;
  }

  // Get company's posted jobs
  Stream<List<JobPost>> getCompanyJobs() {
    return _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: _auth.currentUser?.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => JobPost.fromFirestore(doc)).toList());
  }

  // Update job posting
  Future<void> updateJob(String jobId, JobPost job) async {
    await _firestore.collection('jobs').doc(jobId).update(job.toFirestore());
  }

  // Delete job posting
  Future<void> deleteJob(String jobId) async {
    // Remove job from jobs collection
    await _firestore.collection('jobs').doc(jobId).delete();

    // Remove job ID from company's posted jobs
    await _firestore.collection('companies').doc(_auth.currentUser?.uid).update({
      'postedJobs': FieldValue.arrayRemove([jobId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all verified companies
  Stream<List<Company>> getVerifiedCompanies() {
    return _firestore
        .collection('companies')
        .where('isVerified', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Company.fromFirestore(doc)).toList());
  }

  // Request company verification
  Future<void> requestVerification() async {
    await _firestore.collection('verificationRequests').add({
      'companyId': _auth.currentUser?.uid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
} 