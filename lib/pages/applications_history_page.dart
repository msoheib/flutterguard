import 'package:flutter/material.dart';
import '../widgets/authenticated_layout.dart';
import '../services/job_application_service.dart';
import '../models/job_application.dart';
import '../services/service_locator.dart';

class ApplicationsHistoryPage extends StatefulWidget {
  const ApplicationsHistoryPage({super.key});

  @override
  State<ApplicationsHistoryPage> createState() => _ApplicationsHistoryPageState();
}

class _ApplicationsHistoryPageState extends State<ApplicationsHistoryPage> {
  final List<JobApplication> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      final applications = await getIt<JobApplicationService>().getUserApplications();
      if (mounted) {
        setState(() {
          _applications.clear();
          _applications.addAll(applications);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading applications: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 1,
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: const Text(
                  'تقديماتي',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Applications List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _applications.isEmpty
                        ? const Center(
                            child: Text(
                              'لا يوجد تقديمات حتى الآن',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _applications.length,
                            itemBuilder: (context, index) {
                              final application = _applications[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    application.jobTitle ?? 'وظيفة غير معروفة',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        application.companyName ?? 'شركة غير معروفة',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'الحالة: ${_getStatusInArabic(application.status)}',
                                        style: TextStyle(
                                          color: _getStatusColor(application.status),
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusInArabic(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'pending':
      default:
        return 'قيد المراجعة';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
} 