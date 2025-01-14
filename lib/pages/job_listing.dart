import 'package:flutter/material.dart';
import '../widgets/job_listing_card.dart';
import '../services/job_service.dart';
import '../models/job_post.dart';
import '../screens/job_detail_page.dart';

class JobListings extends StatefulWidget {
  const JobListings({super.key});

  @override
  State<JobListings> createState() => JobListingsState();
}

class JobListingsState extends State<JobListings> {
  final JobService _jobService = JobService();
  List<JobPost> _jobs = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _activeFilters;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      setState(() => _isLoading = true);
      final jobs = await _jobService.getJobs();
      setState(() {
        _jobs = jobs;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            ElevatedButton(
              onPressed: _loadJobs,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _jobs.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return JobListingCard(job: _jobs[index]);
      },
    );
  }
}
