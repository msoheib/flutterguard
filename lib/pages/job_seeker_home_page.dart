import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/authenticated_layout.dart';
import '../widgets/job_listing_card.dart';
import '../services/job_service.dart';
import '../models/job_post.dart';
import '../screens/filter_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/profile_cv_screen.dart';
import '../services/service_locator.dart';

class JobSeekerHomePage extends StatefulWidget {
  const JobSeekerHomePage({super.key});

  @override
  State<JobSeekerHomePage> createState() => _JobSeekerHomePageState();
}

class _JobSeekerHomePageState extends State<JobSeekerHomePage> {
  final List<JobPost> _jobs = [];
  bool _isLoading = true;
  int _totalJobs = 0;
  late final JobService _jobService;

  @override
  void initState() {
    super.initState();
    _jobService = getIt<JobService>();
    _loadJobs();
    _loadTotalJobs();
  }

  Future<void> _loadJobs() async {
    try {
      _jobService.getJobPosts().listen(
        (jobs) {
          if (mounted) {
            setState(() {
              _jobs.clear();
              _jobs.addAll(jobs);
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      print('Error loading jobs: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTotalJobs() async {
    try {
      final jobsRef = FirebaseFirestore.instance.collection('jobs');
      final AggregateQuerySnapshot jobStats = await jobsRef.count().get();
      
      if (mounted) {
        setState(() {
          _totalJobs = jobStats.count ?? 0;
        });
      }
    } catch (e) {
      print('Error loading job stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 0,
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: Column(
          children: [
            // Header
            Container(
              height: 125,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileCvScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            image: const DecorationImage(
                              image: AssetImage('assets/media/icons/avatar.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'أسم التطبيق',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 20,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterBottomSheet,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CA6A8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/media/icons/filter.svg',
                              width: 24,
                              height: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'ابحث هنا...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  InkWell(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6A8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/media/icons/filter.svg',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                height: 169,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CA6A8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x07000000),
                      blurRadius: 12,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _totalJobs.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'الوظائف المقدمة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Jobs Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'آخر الوظائف',
                      style: TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: _jobs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: JobListingCard(job: _jobs[index]),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const FilterBottomSheet(),
        ),
      ),
    );

    if (result != null) {
      // Handle filter results
      setState(() {
        _isLoading = true;
      });
      // Implement filtered job loading here
    }
  }
} 