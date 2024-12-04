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
          final cities = snapshot.docs.map((doc) => doc['name'] as String).toList();
          // Remove duplicates and sort
          final uniqueCities = cities.toSet().toList()..sort();
          return uniqueCities;
        });
  }

  // Add initial cities if they don't exist
  Future<void> initializeCities() async {
    try {
      // Check if cities already exist
      final existingCities = await _firestore.collection('cities').get();
      if (existingCities.docs.isNotEmpty) {
        return; // Cities already initialized
      }

      final cities = [
        'الرياض',
        'جدة',
        'مكة المكرمة',
        'المدينة المنورة',
        'الدمام',
        'الخبر',
        'تبوك',
        'أبها',
        'الطائف',
        'بريدة',
        'نجران',
        'جازان',
        'ينبع',
        'حائل',
        'الجبيل',
        'الخرج',
        'الأحساء',
        'القطيف',
        'خميس مشيط',
        'حفر الباطن'
      ];

      final batch = _firestore.batch();
      final citiesRef = _firestore.collection('cities');

      // Sort cities before adding
      cities.sort();
      
      // Use city name as document ID to prevent duplicates
      for (final city in cities) {
        final doc = citiesRef.doc(city);
        batch.set(doc, {'name': city});
      }

      await batch.commit();
    } catch (e) {
      print('Error initializing cities: $e');
    }
  }
} 