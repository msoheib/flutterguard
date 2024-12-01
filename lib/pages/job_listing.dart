import 'package:flutter/material.dart';
import '../widgets/job_listing_card.dart';
import '../services/job_service.dart';
import '../models/job_post.dart';

class JobListings extends StatefulWidget {
  @override
  State<JobListings> createState() => _JobListingsState();
}

class _JobListingsState extends State<JobListings> {
  final JobService _jobService = JobService();
  List<JobPost> _jobs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      // First, create some sample jobs if none exist
      await _jobService.createSampleJobPostings();
      print('Created sample job postings');

      // Listen to job posts stream
      _jobService.getJobPosts().listen(
        (jobs) {
          print('Received ${jobs.length} jobs');
          setState(() {
            _jobs = jobs;
            _isLoading = false;
            _error = null;
          });
        },
        onError: (error) {
          print('Error loading jobs: $error');
          setState(() {
            _error = error.toString();
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      print('Error in _loadJobs: $e');
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
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadJobs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No jobs found'),
            ElevatedButton(
              onPressed: _loadJobs,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30.5),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          print('Building job card for ${job.title}');
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: JobListingCard(job: job),
          );
        },
      ),
    );
  }
}
