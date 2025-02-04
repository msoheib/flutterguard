import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import 'components/admin_bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminApplicationsPage extends StatefulWidget {
  const AdminApplicationsPage({super.key});

  @override
  State<AdminApplicationsPage> createState() => _AdminApplicationsPageState();
}

class _AdminApplicationsPageState extends State<AdminApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'طلبات التوظيف',
          showBackButton: false,
        ),
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
      bottomNavigationBar: AdminBottomNav(
        currentIndex: 1,
        onTap: (index) => AdminBottomNav.handleNavigation(context, index),
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