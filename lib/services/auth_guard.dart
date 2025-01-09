import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/navigation_service.dart';

class AuthGuard {
  static Future<bool> canActivate(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      NavigationService.navigateTo('/login');
      return false;
    }
    return true;
  }

  static Future<bool> canActivateCompanyRoute(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      NavigationService.navigateTo('/login');
      return false;
    }

    // Check if user is a company
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    if (userDoc.data()?['role'] != 'company') {
      NavigationService.navigateTo('/home');
      return false;
    }

    return true;
  }
} 