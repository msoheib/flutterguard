import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job_profile.dart';
import '../models/job_post.dart';

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
  Stream<List<JobPost>> getJobPosts({Map<String, dynamic>? filters}) {
    Query query = _firestore.collection('jobs');

    if (filters != null) {
      print('Applying filters: $filters'); // Debug print

      // Apply category filter
      if (filters['category'] != null && filters['category'].isNotEmpty) {
        print('Filtering by category: ${filters['category']}');
        query = query.where('type', isEqualTo: filters['category']);
      }

      // Apply region filter
      if (filters['region'] != null && filters['region'].isNotEmpty) {
        print('Filtering by region: ${filters['region']}');
        query = query.where('location', isEqualTo: filters['region']);
      }

      // Apply salary range filter
      if (filters['salaryRange'] != null) {
        final minSalary = (filters['salaryRange']['min'] as double).toInt();
        final maxSalary = (filters['salaryRange']['max'] as double).toInt();
        print('Filtering by salary range: $minSalary - $maxSalary');
        query = query.where('salary.amount', isGreaterThanOrEqualTo: minSalary)
                    .where('salary.amount', isLessThanOrEqualTo: maxSalary);
      }

      // Apply date range filter
      if (filters['dateRange'] != null && filters['dateRange'] is Map) {
        final startDate = (filters['dateRange']['start'] as DateTime);
        final endDate = (filters['dateRange']['end'] as DateTime);
        print('Filtering by date range: $startDate - $endDate');
        query = query.where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
                    .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }
    }

    // First, let's check all jobs without filters
    print('Checking all jobs in collection:');
    _firestore.collection('jobs').get().then((snapshot) {
      print('Total jobs in collection: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Document ${doc.id}:');
        print('  type: ${data['type']}');
        print('  location: ${data['location']}');
        print('  salary: ${data['salary']}');
        print('  skills: ${data['skills']}');
      }
    });

    return query.snapshots().map((snapshot) {
      print('Raw Firestore query results: ${snapshot.docs.length} documents');
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print('Document ${doc.id}:');
        print('  type: ${data['type']}');
        print('  location: ${data['location']}');
        print('  salary: ${data['salary']}');
        print('  skills: ${data['skills']}');
      }

      var jobs = snapshot.docs.map((doc) => JobPost.fromFirestore(doc)).toList();
      print('Retrieved ${jobs.length} jobs before skills filtering');

      // Apply skills filter if specified
      if (filters != null && filters['skills'] != null && filters['skills'].isNotEmpty) {
        print('Filtering by skills: ${filters['skills']}');
        jobs = jobs.where((job) {
          print('Checking job ${job.title}:');
          print('  Job skills: ${job.skills}');
          print('  Filter skills: ${filters['skills']}');
          final hasMatchingSkills = job.skills.any((skill) => filters['skills'].contains(skill));
          print('  Has matching skills: $hasMatchingSkills');
          return hasMatchingSkills;
        }).toList();
        print('${jobs.length} jobs after skills filtering');
      }

      return jobs;
    });
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

  Future<void> applyForJob(String jobId, String userId, String coverLetter) {
    return _firestore.runTransaction((transaction) async {
      // Create application
      DocumentReference applicationRef = _firestore.collection('applications').doc();
      
      // Update job applications count
      DocumentReference jobRef = _firestore.collection('jobs').doc(jobId);
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      transaction.set(applicationRef, {
        'jobId': jobId,
        'userId': userId,
        'status': 'pending',
        'appliedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'coverLetter': coverLetter,
      });

      transaction.update(jobRef, {
        'applicationsCount': FieldValue.increment(1),
      });

      transaction.update(userRef, {
        'applicationCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> createSampleJobs() async {
    final List<Map<String, dynamic>> sampleJobs = [
      {
        'title': 'حارس أمن',
        'company': 'شركة الأمن المتقدم',
        'hirerId': 'sample_hirer_1',
        'description': 'مطلوب حارس أمن للعمل في مجمع سكني',
        'requirements': ['رخصة أمن سارية', 'خبرة سنتين'],
        'location': 'الرياض',
        'salary': {
          'min': 3000,
          'max': 4000,
          'currency': 'SAR'
        },
        'type': 'full-time',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'applicationsCount': 0,
        'filters': {
          'industry': 'security',
          'experience': 2,
          'education': 'high_school',
          'skills': ['security', 'surveillance']
        }
      },
      {
        'title': 'حارس أمن مناوبات',
        'company': 'مجموعة الحماية الأمنية',
        'hirerId': 'sample_hirer_2',
        'description': 'نبحث عن حراس أمن للعمل بنظام المناوبات في مركز تجاري',
        'requirements': ['رخصة أمن', 'لياقة بدنية عالية'],
        'location': 'جدة',
        'salary': {
          'min': 3500,
          'max': 4500,
          'currency': 'SAR'
        },
        'type': 'shift-work',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'applicationsCount': 0,
        'filters': {
          'industry': 'security',
          'experience': 1,
          'education': 'high_school',
          'skills': ['security', 'physical_fitness']
        }
      },
      {
        'title': 'مشرف أمن',
        'company': 'الشركة السعودية للحراسات الأمنية',
        'hirerId': 'sample_hirer_3',
        'description': 'مطلوب مشرف أمن للإشراف على فريق من الحراس',
        'requirements': [
          'خبرة 5 سنوات',
          'شهادة في الأمن والسلامة',
          'مهارات قيادية'
        ],
        'location': 'الدمام',
        'salary': {
          'min': 5000,
          'max': 7000,
          'currency': 'SAR'
        },
        'type': 'full-time',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'applicationsCount': 0,
        'filters': {
          'industry': 'security',
          'experience': 5,
          'education': 'bachelors',
          'skills': ['security_management', 'team_leadership']
        }
      },
      {
        'title': 'حارس أمن مطار',
        'company': 'شركة أمن المطارات',
        'hirerId': 'sample_hirer_4',
        'description': 'وظائف شاغرة لحراس أمن في مطار الملك خالد الدولي',
        'requirements': [
          'إجادة اللغة الإنجليزية',
          'خبرة في أمن المطارات',
          'اجتياز الفحص الأمني'
        ],
        'location': 'الرياض',
        'salary': {
          'min': 4500,
          'max': 6000,
          'currency': 'SAR'
        },
        'type': 'full-time',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'applicationsCount': 0,
        'filters': {
          'industry': 'aviation_security',
          'experience': 3,
          'education': 'diploma',
          'skills': ['airport_security', 'english_language']
        }
      },
      {
        'title': 'حارس أمن ليلي',
        'company': 'مجمع الرياض التجاري',
        'hirerId': 'sample_hirer_5',
        'description': 'مطلوب حارس أمن للفترة المسائية في مجمع تجاري',
        'requirements': ['رخصة أمن سارية', 'القدرة على العمل ليلاً'],
        'location': 'الرياض',
        'salary': {
          'min': 3800,
          'max': 4200,
          'currency': 'SAR'
        },
        'type': 'night-shift',
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'applicationsCount': 0,
        'filters': {
          'industry': 'security',
          'experience': 1,
          'education': 'high_school',
          'skills': ['night_security', 'surveillance']
        }
      }
    ];

    for (var job in sampleJobs) {
      await _firestore.collection('jobs').add(job);
    }
  }

  Future<void> createSampleJobPostings() async {
    print('Checking for existing jobs...');
    final QuerySnapshot snapshot = await _firestore.collection('jobs').get();
    print('Found ${snapshot.docs.length} existing jobs');

    if (snapshot.docs.isEmpty) {
      final List<Map<String, dynamic>> sampleJobs = [
        {
          'title': 'حارس أمن',
          'company': 'شركة الأمن المتقدم',
          'location': 'الرياض',
          'type': 'حارس أمن',
          'salary': {'amount': 3000, 'currency': 'ريال'},
          'description': 'نبحث عن حارس أمن ذو خبرة',
          'requirements': ['رخصة قيادة', 'شهادة أمن'],
          'qualifications': ['دبلوم', 'خبرة 2 سنة'],
          'skills': ['حارس أمن', 'مراقبة الكاميرات', 'اللياقة البدنية'],
          'status': 'active',
          'hirerId': 'sample',
          'applicationsCount': 0,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          'filters': {},
        },
        {
          'title': 'مشرف أمن',
          'company': 'شركة الحماية الشاملة',
          'location': 'جدة',
          'type': 'مشرف أمن',
          'salary': {'amount': 4000, 'currency': 'ريال'},
          'description': 'مطلوب مشرف أمن للعمل في مجمع تجاري',
          'requirements': ['رخصة قيادة', 'شهادة أمن متقدمة'],
          'qualifications': ['بكالوريوس', 'خبرة 4 سنوات'],
          'skills': ['إدارة الأزمات', 'مهارات التواصل', 'تقييم الثغرات'],
          'status': 'active',
          'hirerId': 'sample',
          'applicationsCount': 0,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          'filters': {},
        },
      ];

      print('Creating sample jobs:');
      for (var jobData in sampleJobs) {
        print('Creating job:');
        print('  type: ${jobData['type']}');
        print('  location: ${jobData['location']}');
        print('  salary: ${jobData['salary']}');
        print('  skills: ${jobData['skills']}');
        await _firestore.collection('jobs').add(jobData);
      }
      print('Sample jobs created successfully');
    }
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
}
