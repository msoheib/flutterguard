import 'package:flutter/material.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_support_page.dart';

class AdminApplicationsPage extends StatefulWidget {
  const AdminApplicationsPage({super.key});

  @override
  State<AdminApplicationsPage> createState() => _AdminApplicationsPageState();
}

class _AdminApplicationsPageState extends State<AdminApplicationsPage> {
  // Visual index 2 corresponds to Companies/Applications in the RTL navbar
  int _selectedNavIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const NotificationAppBar(
        title: 'الشركات',
        notificationCount: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final applications = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index].data() as Map<String, dynamic>;
              
              return Card(
                child: ListTile(
                  title: Text(application['jobTitle'] ?? 'وظيفة'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(application['companyName'] ?? 'شركة'),
                      Text(application['applicantName'] ?? 'متقدم'),
                    ],
                  ),
                  trailing: Text(
                    application['status'] ?? 'معلق',
                    style: TextStyle(
                      color: _getStatusColor(application['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    // Navigate to application details
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: AdminNavBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          // The AdminNavBar will handle navigation directly
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 