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

  Future<QuerySnapshot> getJobs({
    String? industry,
    String? location,
    String? jobType,
    List<String>? skills,
    int? minSalary,
    int? maxSalary,
  }) {
    Query query = _firestore.collection('jobs')
        .where('status', isEqualTo: 'active');

    if (industry != null) {
      query = query.where('filters.industry', isEqualTo: industry);
    }

    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }

    if (jobType != null) {
      query = query.where('type', isEqualTo: jobType);
    }

    if (minSalary != null) {
      query = query.where('salary.min', isGreaterThanOrEqualTo: minSalary);
    }

    if (maxSalary != null) {
      query = query.where('salary.max', isLessThanOrEqualTo: maxSalary);
    }

    // For skills, since it's an array, we use arrayContainsAny
    if (skills != null && skills.isNotEmpty) {
      query = query.where('filters.skills', arrayContainsAny: skills);
    }

    return query
        .orderBy('createdAt', descending: true)
        .get();
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
}
