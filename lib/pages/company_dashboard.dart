import 'package:flutter/material.dart';
import '../models/company.dart';
import '../models/job_post.dart';
import '../services/company_service.dart';
import '../screens/create_job_page.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({Key? key}) : super(key: key);

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  final CompanyService _companyService = CompanyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateJobPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<Company?>(
        stream: _companyService.getCompanyProfile(),
        builder: (context, companySnapshot) {
          if (companySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!companySnapshot.hasData) {
            return const Center(child: Text('لم يتم العثور على الشركة'));
          }

          final company = companySnapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Company Profile Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!company.isVerified)
                                TextButton(
                                  onPressed: () => _companyService.requestVerification(),
                                  child: const Text('طلب التحقق'),
                                ),
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(company.logo),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            company.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(company.industry),
                          Text(company.location),
                          if (company.isVerified)
                            const Chip(
                              label: Text('تم التحقق'),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Posted Jobs
                  const Text(
                    'الوظائف المنشورة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<JobPost>>(
                    stream: _companyService.getCompanyJobs(),
                    builder: (context, jobsSnapshot) {
                      if (jobsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!jobsSnapshot.hasData || jobsSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('لا توجد وظائف منشورة'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: jobsSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          final job = jobsSnapshot.data![index];
                          return Card(
                            child: ListTile(
                              title: Text(job.title),
                              subtitle: Text(job.location),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('تعديل'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('حذف'),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    // Navigate to edit page
                                  } else if (value == 'delete') {
                                    await _companyService.deleteJob(job.id);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 