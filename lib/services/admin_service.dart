import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if current user is admin
  Future<bool> isAdmin() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return false;

    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['role'] == 'admin';
  }

  // Get all support tickets
  Stream<List<Map<String, dynamic>>> getSupportTickets() {
    return _firestore
        .collection('support_chats')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'userId': data['userId'],
          'status': data['status'],
          'createdAt': data['createdAt'],
          'lastMessage': data['lastMessage'],
        };
      }).toList();
    });
  }

  // Assign ticket to admin
  Future<void> assignTicket(String ticketId) async {
    final adminId = _auth.currentUser?.uid;
    if (adminId == null) throw Exception('Admin not authenticated');

    await _firestore.collection('support_chats').doc(ticketId).update({
      'assignedTo': adminId,
      'status': 'in_progress',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Close ticket
  Future<void> closeTicket(String ticketId, String resolution) async {
    await _firestore.collection('support_chats').doc(ticketId).update({
      'status': 'closed',
      'resolution': resolution,
      'closedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
} 