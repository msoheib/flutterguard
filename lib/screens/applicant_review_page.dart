import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/navigation/app_bars/custom_app_bar.dart';

class ApplicantReviewPage extends StatelessWidget {
  const ApplicantReviewPage({super.key});

  Future<void> _updateApplicationStatus(String applicationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({
        'status': newStatus,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating application status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'التقديمات',
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('applications').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('حدث خطأ ما'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا توجد تقديمات حالياً'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final application = snapshot.data!.docs[index];
                    final data = application.data() as Map<String, dynamic>;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data['jobTitle'] ?? 'وظيفة غير معروفة',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تاريخ التقديم: ${_formatDate(data['appliedAt'])}',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton<String>(
                                  value: data['status'] ?? 'pending',
                                  items: [
                                    DropdownMenuItem(
                                      value: 'pending',
                                      child: Text(
                                        'قيد المراجعة',
                                        style: TextStyle(
                                          color: _getStatusColor('pending'),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'accepted',
                                      child: Text(
                                        'مقبول',
                                        style: TextStyle(
                                          color: _getStatusColor('accepted'),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'rejected',
                                      child: Text(
                                        'مرفوض',
                                        style: TextStyle(
                                          color: _getStatusColor('rejected'),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'need_details',
                                      child: Text(
                                        'يحتاج تفاصيل',
                                        style: TextStyle(
                                          color: _getStatusColor('need_details'),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _updateApplicationStatus(application.id, newValue);
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () => _viewApplicationDetails(context, application.id),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF4CA6A8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    'عرض التفاصيل',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'غير متوفر';
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'غير متوفر';
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'need_details':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _viewApplicationDetails(BuildContext context, String applicationId) {
    Navigator.pushNamed(
      context,
      '/application-details',
      arguments: applicationId,
    );
  }
} 