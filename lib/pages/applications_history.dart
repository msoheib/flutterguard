import 'package:flutter/material.dart';
import '../services/application_service.dart';
import '../models/application.dart';

class ApplicationsHistory extends StatefulWidget {
  const ApplicationsHistory({super.key});

  @override
  State<ApplicationsHistory> createState() => _ApplicationsHistoryState();
}

class _ApplicationsHistoryState extends State<ApplicationsHistory> {
  final ApplicationService _applicationService = ApplicationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _applicationService.getJobseekerApplications(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final applications = snapshot.data!.docs
              .map((doc) => Application.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return ApplicationHistoryCard(application: application);
            },
          );
        },
      ),
    );
  }
} 