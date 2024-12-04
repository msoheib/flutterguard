import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/status_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/company_stats_panels.dart';
import '../widgets/recent_applicants_list.dart';
import '../pages/profile_cv_screen.dart';
import '../widgets/authenticated_layout.dart';
import '../screens/filter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        
        if (userDoc.exists) {
          setState(() {
            userRole = userDoc.data()?['role'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error getting user role: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showFilterBottomSheet(BuildContext context) async {
    print("Showing filter bottom sheet");
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
  }

  Widget _buildCompanyHome() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SearchBarWidget(
          onFilterTap: () {
            print("Filter button tapped in home page");
            _showFilterBottomSheet(context);
          },
          onSearch: (value) {
            print('Search query: $value');
          },
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.5),
          child: CompanyStatsPanels(
            postedJobs: 29,
            totalApplicants: 100,
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.5),
          child: RecentApplicantsList(),
        ),
      ],
    );
  }

  Widget _buildJobSeekerHome() {
    return Column(
      children: [
        const SizedBox(height: 20),
        SearchBarWidget(
          onFilterTap: () {
            print("Filter button tapped in home page");
            _showFilterBottomSheet(context);
          },
          onSearch: (value) {
            print('Search query: $value');
          },
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('jobs')
                .where('status', isEqualTo: 'active')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'حدث خطأ: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Refresh the page
                            });
                          },
                          child: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final jobs = snapshot.data!.docs;
              
              if (jobs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'لا توجد وظائف متاحة حالياً',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'الوظائف المتاحة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                job['title'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                job['company'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Color(0xFF4CA6A8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                job['location'] ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement job application
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF4CA6A8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'تقديم',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    job['salary']?['amount']?.toString() ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CA6A8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AuthenticatedLayout(
      currentIndex: 3,
      onNavItemTap: (index) {
        // Navigation is now handled by the navbar itself
      },
      child: Column(
        children: [
          StatusBar(
            title: 'أسم التطبيق',
            onNotificationTap: () {
              // Handle notification tap
            },
            onProfileTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileCvScreen(),
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: userRole == 'company' 
                ? _buildCompanyHome()
                : _buildJobSeekerHome(),
            ),
          ),
        ],
      ),
    );
  }
}
