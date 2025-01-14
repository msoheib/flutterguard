import 'package:flutter/material.dart';
import '../services/job_application_service.dart';
import '../models/application.dart';
import '../widgets/user_route_wrapper.dart';
import '../widgets/application_card.dart';

class ApplicationsHistoryPage extends StatelessWidget {
  static final JobApplicationService _applicationService = JobApplicationService();

  const ApplicationsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserRouteWrapper(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: Column(
          children: [
            Container(
              height: 125,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: const SafeArea(
                child: Center(
                  child: Text(
                    'تقديماتي',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: StreamBuilder<List<Application>>(
                  stream: _applicationService.getUserApplications(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final applications = snapshot.data!;

                    if (applications.isEmpty) {
                      return const Center(child: Text('لا توجد تقديمات'));
                    }

                    return ListView.builder(
                      itemCount: applications.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ApplicationCard(
                            application: applications[index],
                            onViewDetails: () {
                              // Navigate to application details
                              Navigator.pushNamed(
                                context,
                                '/jobseeker/applications/details',
                                arguments: applications[index],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 