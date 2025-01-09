import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/navigation_service.dart';

class SupportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Start live chat
  Future<void> startLiveChat() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Create a support chat
    final chatRef = await _firestore.collection('support_chats').add({
      'userId': userId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Navigate to chat
    Navigator.pushNamed(
      NavigationService.navigatorKey.currentContext!,
      '/support-chat',
      arguments: chatRef.id,
    );
  }

  // Send email
  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      queryParameters: {
        'subject': 'طلب دعم فني',
        'body': 'مرحباً،\n\n',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw Exception('Could not launch email');
    }
  }

  // Make phone call
  Future<void> makePhoneCall() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+966XXXXXXXXX',
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw Exception('Could not launch phone call');
    }
  }

  // Get FAQ items
  Stream<List<Map<String, dynamic>>> getFaqItems() {
    return _firestore
        .collection('faq')
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'question': data['question'],
          'answer': data['answer'],
        };
      }).toList();
    });
  }
} 