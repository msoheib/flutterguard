import 'package:flutter/material.dart';
import '../services/job_service.dart';

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  late final JobService _jobService;

  @override
  void initState() {
    super.initState();
    _jobService = getIt<JobService>();
  }

  @override
  Widget build(BuildContext context) {
    // ... rest of your code
  }
} 