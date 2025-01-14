import 'package:cloud_firestore/cloud_firestore.dart';

class CityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all cities
  Stream<List<String>> getCities() {
    return _firestore
        .collection('cities')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => doc.data()['name'] as String)
              .toList()
            ..sort((a, b) => a.compareTo(b));
        });
  }

  // Add initial cities if they don't exist
  Future<void> initializeCities() async {
    try {
      // Check if cities collection exists and has documents
      final citiesCollection = await _firestore.collection('cities').get();
      
      // If collection is empty, initialize with default cities
      if (citiesCollection.docs.isEmpty) {
        final cities = [
          'الرياض', 'جدة', 'مكة المكرمة', 'المدينة المنورة', 'الدمام',
          'الخبر', 'تبوك', 'أبها', 'الطائف', 'بريدة', 'نجران', 'جازان',
          'ينبع', 'حائل', 'الجبيل', 'الخرج', 'الأحساء', 'القطيف',
          'خميس مشيط', 'حفر الباطن', 'الظهران', 'عرعر', 'سكاكا',
          'القريات', 'الباحة', 'بيشة', 'الرس', 'المجمعة', 'القنفذة',
          'محايل عسير', 'شرورة', 'الدوادمي', 'صبيا', 'عنيزة', 'القويعية',
          'أبو عريش', 'نجران', 'الزلفي', 'الرس', 'عفيف', 'الجموم',
          'رابغ', 'شقراء', 'الليث', 'الخفجي', 'الدرعية', 'طبرجل',
          'بدر', 'رفحاء', 'رأس تنورة', 'البكيرية'
        ];

        // Sort cities before adding
        cities.sort();

        // Create a batch write
        final batch = _firestore.batch();
        
        // Add each city as a separate document
        for (final city in cities) {
          final docRef = _firestore.collection('cities').doc();
          batch.set(docRef, {
            'name': city,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // Commit the batch
        await batch.commit();
        print('Cities initialized successfully');
      }
    } catch (e) {
      print('Error initializing cities: $e');
      rethrow;
    }
  }
} 