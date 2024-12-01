// lib/pages/job_listings_page.dart
import 'package:flutter/material.dart';
import '../services/job_service.dart';

class JobListingsPage extends StatelessWidget {
  const JobListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Job Listings Page'),
      ),
    );
  }
}