// lib/pages/job_listings_page.dart
import 'package:flutter/material.dart';

class JobListingsPage extends StatelessWidget {
  const JobListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Listings')),
      body: Center(child: Text('Job listings will be displayed here')),
    );
  }
}