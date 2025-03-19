import 'package:flutter/material.dart';
import '../services/job_application_service.dart';
import '../services/job_service.dart';
import '../widgets/user_route_wrapper.dart';
import '../widgets/job_listing_card.dart';
import '../models/job_post.dart';
import '../screens/job_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationsHistoryPage extends StatefulWidget {
  static final JobApplicationService _applicationService = JobApplicationService();

  const ApplicationsHistoryPage({super.key});

  @override
  State<ApplicationsHistoryPage> createState() => _ApplicationsHistoryPageState();
}

class _ApplicationsHistoryPageState extends State<ApplicationsHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final JobService _jobService = JobService();
  final JobApplicationService _applicationService = JobApplicationService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Show confirmation dialog for cancelling application
  Future<void> _showCancelConfirmation(String jobId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إلغاء التقديم',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد إلغاء تقديمك لهذه الوظيفة؟',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Color(0xFF6A6A6A),
                fontFamily: 'Cairo',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _cancelApplication(jobId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFFE53935),
            ),
            child: const Text(
              'تأكيد الإلغاء',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  // Cancel application function
  Future<void> _cancelApplication(String jobId) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _applicationService.cancelApplication(jobId);
      
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إلغاء تقديمك بنجاح'),
          backgroundColor: Color(0xFF4CA6A8),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء إلغاء التقديم: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return UserRouteWrapper(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CA6A8)))
            : Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'تقديماتي',
                              style: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 20,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xFF4CA6A8),
                            unselectedLabelColor: const Color(0xFF6A6A6A),
                            indicatorColor: const Color(0xFF4CA6A8),
                            tabs: const [
                              Tab(text: 'التقديمات'),
                              Tab(text: 'الوظائف المحفوظة'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Applications Tab
                        _buildApplicationsTab(user),
                        
                        // Bookmarked Jobs Tab
                        _buildBookmarkedJobsTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildApplicationsTab(User? user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('appliedDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final applications = snapshot.data?.docs ?? [];

        // Debug: Print all application statuses to console for debugging
        for (var app in applications) {
          final data = app.data() as Map<String, dynamic>;
          print('Application status: ${data['status']}, ID: ${app.id}');
        }

        if (applications.isEmpty) {
          return const Center(
            child: Text(
              'لم تقم بالتقديم على أي وظيفة بعد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: Color(0xFF6A6A6A),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index].data() as Map<String, dynamic>;
            final jobId = application['jobId'] ?? '';
            final status = application['status'] ?? 'pending';
            
            // Make sure salary is properly formatted
            Map<String, dynamic> salaryMap = {};
            if (application['salary'] is Map) {
              salaryMap = Map<String, dynamic>.from(application['salary']);
            } else if (application['salaryMap'] is Map) {
              salaryMap = Map<String, dynamic>.from(application['salaryMap']);
            } else {
              // Fallback if no proper salary data
              salaryMap = {
                'amount': application['salary'] is num ? application['salary'] : 0,
                'currency': 'SAR'
              };
            }
            
            // Make sure location is properly formatted
            Map<String, dynamic> locationMap = {};
            if (application['location'] is Map) {
              locationMap = Map<String, dynamic>.from(application['location']);
            } else if (application['locationMap'] is Map) {
              locationMap = Map<String, dynamic>.from(application['locationMap']);
            } else {
              // Fallback if no proper location data
              locationMap = {
                'city': application['location'] is String ? application['location'] : '',
              };
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: JobListingCard(
                title: application['jobTitle'] ?? '',
                company: application['companyName'] ?? application['company'] ?? '',
                location: locationMap,
                salary: salaryMap,
                jobType: application['jobType'] ?? '',
                workType: application['workType'] ?? '',
                status: status,
                jobId: jobId,
                onTap: () async {
                  // Get the job document
                  final jobDoc = await FirebaseFirestore.instance
                      .collection('jobs')
                      .doc(jobId)
                      .get();
                  
                  if (jobDoc.exists && context.mounted) {
                    // Convert to JobPost and navigate
                    final job = JobPost.fromFirestore(jobDoc);
                    
                    // Use await to detect when user returns from JobDetailPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage(job: job),
                      ),
                    );
                    
                    // Force UI refresh when returning
                    if (mounted) {
                      setState(() {});
                    }
                  }
                },
                buttonText: _getStatusText(status),
                buttonColor: _getStatusColor(status),
                // Show cancel button for pending or submitted applications
                onCancelPressed: (status.toLowerCase() == 'pending' || status.toLowerCase() == 'submitted') 
                    ? () => _showCancelConfirmation(jobId) 
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookmarkedJobsTab() {
    return StreamBuilder<List<JobPost>>(
      stream: _jobService.getFavoriteJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final jobs = snapshot.data ?? [];

        if (jobs.isEmpty) {
          return const Center(
            child: Text(
              'لم تقم بحفظ أي وظيفة بعد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: Color(0xFF6A6A6A),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: JobListingCard(
                title: job.title,
                company: job.company,
                location: job.location,
                salary: job.salary,
                jobType: job.type,
                workType: job.workType,
                job: job,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailPage(job: job),
                    ),
                  );
                },
                buttonText: 'عرض التفاصيل',
                buttonColor: const Color(0xFF4CA6A8),
              ),
            );
          },
        );
      },
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'submitted': // Also treat 'submitted' status
        return 'قيد المراجعة';
      case 'reviewed':
        return 'تمت المراجعة';
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'قيد المراجعة'; // Default to "under review" for unknown statuses
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'submitted': // Also treat 'submitted' status
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange; // Default to orange for unknown statuses
    }
  }
} 