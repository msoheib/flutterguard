import 'package:flutter/material.dart';
import '../services/role_service.dart';
import '../services/job_service.dart';
import '../models/user.dart' as app_user;
import '../services/service_locator.dart';

class CompanyStatsPanels extends StatelessWidget {
  final app_user.UserRole userRole;

  const CompanyStatsPanels({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final jobService = getIt<JobService>();

    return StreamBuilder<int>(
      stream: jobService.getActiveJobsCount(),
      builder: (context, snapshot) {
        final activeJobs = snapshot.data ?? 0;

        return Row(
          children: [
            Expanded(
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      activeJobs.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CA6A8),
                      ),
                    ),
                    const Text(
                      'الوظائف النشطة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (RoleService.canViewApplicantStats(userRole))
              Expanded(
                child: StreamBuilder<int>(
                  stream: jobService.getTotalApplicantsCount(),
                  builder: (context, snapshot) {
                    final totalApplicants = snapshot.data ?? 0;
                    
                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalApplicants.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CA6A8),
                            ),
                          ),
                          const Text(
                            'إجمالي المتقدمين',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
} 