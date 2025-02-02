import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/admin_user.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current admin ID
  String? get currentAdminId => _auth.currentUser?.uid;

  // Check if current user is admin
  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data()?['role'] == 'admin' || doc.data()?['role'] == 'superadmin';
  }

  // Get admin details
  Future<AdminUser?> getAdminDetails(String adminId) async {
    final doc = await _firestore.collection('admins').doc(adminId).get();
    if (!doc.exists) return null;
    return AdminUser.fromFirestore(doc);
  }

  // Ban a user
  Future<void> banUser(String userId) async {
    final batch = _firestore.batch();
    
    // Update user document
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'isBanned': true,
      'bannedAt': FieldValue.serverTimestamp(),
      'bannedBy': _auth.currentUser?.uid,
    });

    // Add to banned users collection
    final bannedRef = _firestore.collection('bannedUsers').doc(userId);
    batch.set(bannedRef, {
      'userId': userId,
      'bannedAt': FieldValue.serverTimestamp(),
      'bannedBy': _auth.currentUser?.uid,
    });

    await batch.commit();
  }

  // Ban a phone number
  Future<void> banPhoneNumber(String phoneNumber) async {
    await _firestore.collection('bannedPhoneNumbers').doc().set({
      'phoneNumber': phoneNumber,
      'bannedAt': FieldValue.serverTimestamp(),
      'bannedBy': _auth.currentUser?.uid,
    });
  }

  // Delete user account
  Future<void> deleteUserAccount(String userId) async {
    final batch = _firestore.batch();

    // Delete user document
    final userRef = _firestore.collection('users').doc(userId);
    batch.delete(userRef);

    // Delete user's applications
    final applications = await _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .get();
    for (var doc in applications.docs) {
      batch.delete(doc.reference);
    }

    // Delete user's chats
    final chats = await _firestore
        .collection('chats')
        .where('jobSeekerId', isEqualTo: userId)
        .get();
    for (var doc in chats.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update({
      'profile': data,
      'lastUpdated': FieldValue.serverTimestamp(),
      'updatedBy': _auth.currentUser?.uid,
    });
  }

  // Get support chats
  Stream<QuerySnapshot> getSupportChats() {
    return _firestore
        .collection('supportChats')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Handle support chat
  Future<void> handleSupportChat(String chatId, String message) async {
    final batch = _firestore.batch();

    // Add message
    final messageRef = _firestore.collection('supportMessages').doc();
    batch.set(messageRef, {
      'chatId': chatId,
      'message': message,
      'sentBy': _auth.currentUser?.uid,
      'sentAt': FieldValue.serverTimestamp(),
      'isAdminMessage': true,
    });

    // Update chat
    final chatRef = _firestore.collection('supportChats').doc(chatId);
    batch.update(chatRef, {
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadUser': true,
    });

    await batch.commit();
  }

  // Get banned users
  Stream<QuerySnapshot> getBannedUsers() {
    return _firestore
        .collection('bannedUsers')
        .orderBy('bannedAt', descending: true)
        .snapshots();
  }

  // Get banned phone numbers
  Stream<QuerySnapshot> getBannedPhoneNumbers() {
    return _firestore
        .collection('bannedPhoneNumbers')
        .orderBy('bannedAt', descending: true)
        .snapshots();
  }

  // Unban user
  Future<void> unbanUser(String userId) async {
    final batch = _firestore.batch();

    // Update user document
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'isBanned': false,
      'unbannedAt': FieldValue.serverTimestamp(),
      'unbannedBy': _auth.currentUser?.uid,
    });

    // Remove from banned users collection
    final bannedRef = _firestore.collection('bannedUsers').doc(userId);
    batch.delete(bannedRef);

    await batch.commit();
  }

  // Unban phone number
  Future<void> unbanPhoneNumber(String documentId) async {
    await _firestore.collection('bannedPhoneNumbers').doc(documentId).delete();
  }

  // Get user analytics
  Future<Map<String, dynamic>> getUserAnalytics() async {
    final users = await _firestore.collection('users').get();
    final companies = users.docs.where((doc) => doc.data()['role'] == 'company').length;
    final jobSeekers = users.docs.where((doc) => doc.data()['role'] == 'jobseeker').length;
    final banned = users.docs.where((doc) => doc.data()['isBanned'] == true).length;

    return {
      'totalUsers': users.size,
      'companies': companies,
      'jobSeekers': jobSeekers,
      'bannedUsers': banned,
    };
  }

  // Get job analytics
  Future<Map<String, dynamic>> getJobAnalytics() async {
    final jobs = await _firestore.collection('jobs').get();
    final applications = await _firestore.collection('applications').get();

    return {
      'totalJobs': jobs.size,
      'totalApplications': applications.size,
      'averageApplicationsPerJob': jobs.size > 0 
          ? applications.size / jobs.size 
          : 0,
    };
  }

  // Get dashboard statistics
  Future<Map<String, int>> getDashboardStats() async {
    final jobs = await _firestore.collection('jobs').count().get();
    final companies = await _firestore.collection('users')
        .where('role', isEqualTo: 'company')
        .where('isApproved', isEqualTo: true)
        .count()
        .get();
    final users = await _firestore.collection('users')
        .where('role', isEqualTo: 'jobseeker')
        .count()
        .get();

    return {
      'totalJobs': jobs.count ?? 0,
      'totalCompanies': companies.count ?? 0,
      'totalUsers': users.count ?? 0,
    };
  }

  // Get pending company approvals
  Stream<QuerySnapshot> getPendingCompanyApprovals() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'company')
        .where('isApproved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Stream pending company approvals
  Stream<List<Map<String, dynamic>>> getPendingCompanies() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'company')
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'name': data['name'] ?? '',
              'email': data['email'] ?? '',
              'phoneNumber': data['phoneNumber'] ?? '',
              'createdAt': data['createdAt'],
            };
          }).toList();
        });
  }

  // Approve a company
  Future<void> approveCompany(String companyId) async {
    await _firestore.collection('users').doc(companyId).update({
      'isApproved': true,
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  // Reject a company
  Future<void> rejectCompany(String companyId) async {
    // First get the company data
    final companyDoc = await _firestore.collection('users').doc(companyId).get();
    final batch = _firestore.batch();

    // Delete any jobs posted by this company
    final jobsQuery = await _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: companyId)
        .get();
    
    for (var doc in jobsQuery.docs) {
      batch.delete(doc.reference);
    }

    // Delete the company user document
    batch.delete(companyDoc.reference);

    // Commit the batch
    await batch.commit();
  }

  // Get available admins for support chat assignment
  Future<List<AdminUser>> getAvailableAdmins() async {
    final adminsSnapshot = await _firestore
        .collection('admins')
        .where('isAvailable', isEqualTo: true)
        .get();

    return adminsSnapshot.docs
        .map((doc) => AdminUser.fromFirestore(doc))
        .toList();
  }

  // Assign support chat to admin
  Future<void> assignSupportChat(String chatId, String adminId) async {
    await _firestore.collection('supportChats').doc(chatId).update({
      'assignedTo': adminId,
      'assignedAt': FieldValue.serverTimestamp(),
      'status': 'assigned',
    });
  }

  // Get admin's assigned chats
  Stream<QuerySnapshot> getAdminSupportChats(String adminId) {
    return _firestore
        .collection('supportChats')
        .where('assignedTo', isEqualTo: adminId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get unassigned support chats
  Stream<QuerySnapshot> getUnassignedSupportChats() {
    return _firestore
        .collection('supportChats')
        .where('assignedTo', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update admin availability
  Future<void> updateAdminAvailability(bool isAvailable) async {
    await _firestore
        .collection('admins')
        .doc(_auth.currentUser?.uid)
        .update({'isAvailable': isAvailable});
  }
} 