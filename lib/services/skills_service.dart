import 'package:cloud_firestore/cloud_firestore.dart';

class SkillsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all predefined skills
  Stream<List<String>> getSkills() {
    return _firestore
        .collection('skills')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data()['name'] as String)
              .toList()
            ..sort((a, b) => a.compareTo(b));
        });
  }

  // Initialize predefined skills if they don't exist
  Future<void> initializeSkills() async {
    try {
      final skillsCollection = await _firestore.collection('skills').get();
      
      if (skillsCollection.docs.isEmpty) {
        final skills = [
          'مهارات الاتصال',
          'العمل الجماعي',
          'حل المشكلات',
          'المراقبة الأمنية',
          'إدارة الأزمات',
          'الإسعافات الأولية',
          'مكافحة الحرائق',
          'التحكم في الدخول',
          'تقنيات المراقبة',
          'الأمن السيبراني',
          'اللياقة البدنية',
          'القيادة',
          'إعداد التقارير',
          'التحقيق الأمني',
          'إدارة المخاطر',
          'الوعي الأمني',
          'التدريب الأمني',
          'الدفاع عن النفس',
          'إدارة الطوارئ',
          'مراقبة الكاميرات',
          'التوثيق الأمني',
          'الأمن المادي',
          'حماية الشخصيات',
          'أمن المنشآت',
          'أمن المعلومات',
        ];

        final batch = _firestore.batch();
        
        for (final skill in skills) {
          final docRef = _firestore.collection('skills').doc();
          batch.set(docRef, {
            'name': skill,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();
        print('Skills initialized successfully');
      }
    } catch (e) {
      print('Error initializing skills: $e');
      rethrow;
    }
  }
} 