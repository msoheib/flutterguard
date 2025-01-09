import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  try {
    // Get all applications
    final QuerySnapshot applications = await firestore.collection('applications').get();
    
    // Delete each application
    for (var doc in applications.docs) {
      await doc.reference.delete();
      print('Deleted application ${doc.id}');
    }
    
    // Get all jobs to reset their applicationsCount
    final QuerySnapshot jobs = await firestore.collection('jobs').get();
    
    // Reset applications count and clear applications map for each job
    for (var doc in jobs.docs) {
      await doc.reference.update({
        'applicationsCount': 0,
        'applications': {},
      });
      print('Reset applications for job ${doc.id}');
    }
    
    // Get all users to reset their applicationCount
    final QuerySnapshot users = await firestore.collection('users').get();
    
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
  }
} 