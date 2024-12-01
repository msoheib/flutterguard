import 'package:flutter/material.dart';
import '../widgets/job_listing_card.dart';
import '../services/job_service.dart';
import '../models/job_post.dart';

class JobListings extends StatefulWidget {
  const JobListings({Key? key}) : super(key: key);

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
      await _jobService.createSampleJobPostings();
      print('Created sample job postings');

      _jobService.getJobPosts(filters: _activeFilters).listen(
        (jobs) {
          print('Received ${jobs.length} jobs with filters: $_activeFilters');
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

  void updateFilters(Map<String, dynamic> filters) {
    print('Updating filters in JobListings: $filters');
    setState(() {
      _activeFilters = filters;
      _isLoading = true;
    });
    _loadJobs();
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
            if (_activeFilters != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    _activeFilters = null;
                    _loadJobs();
                  });
                },
                child: const Text('Clear Filters'),
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
