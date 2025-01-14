import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/job_application.dart';

class JobApplicantsPage extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicantsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobApplicantsPage> createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 125,
      decoration: const ShapeDecoration(
        color: Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            const Text(
              'المتقدمين للوظيفة',
              style: TextStyle(
                color: Color(0xFF6A6A6A),
                fontSize: 20,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 44,
                height: 44,
                decoration: ShapeDecoration(
                  color: const Color(0xFF4CA6A8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'ابحث هنا...',
                  hintStyle: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Container(
            width: 44,
            height: 44,
            decoration: ShapeDecoration(
              color: const Color(0xFF4CA6A8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Implement search functionality if needed
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: widget.jobId)
          .orderBy('appliedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final applications = snapshot.data!.docs
            .map((doc) => JobApplication.fromFirestore(doc))
            .where((application) => 
              _searchQuery.isEmpty || 
              application.userId.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (applications.isEmpty) {
          return const Center(child: Text('لا يوجد متقدمين'));
        }

        return ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];
            return _buildApplicantCard(application);
          },
        );
      },
    );
  }

  Widget _buildApplicantCard(JobApplication application) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(application.userId),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تاريخ التقديم: ${_formatDate(application.appliedAt)}'),
            const SizedBox(height: 4),
            _buildStatusChip(application.status),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (String status) => _updateApplicationStatus(application, status),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: JobApplication.STATUS_PENDING,
              child: Text('قيد المراجعة'),
            ),
            const PopupMenuItem<String>(
              value: JobApplication.STATUS_REVIEWED,
              child: Text('تمت المراجعة'),
            ),
            const PopupMenuItem<String>(
              value: JobApplication.STATUS_ACCEPTED,
              child: Text('قبول'),
            ),
            const PopupMenuItem<String>(
              value: JobApplication.STATUS_REJECTED,
              child: Text('رفض'),
            ),
          ],
        ),
        onTap: () => _showApplicationDetails(application),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case JobApplication.STATUS_PENDING:
        chipColor = Colors.orange;
        statusText = 'قيد المراجعة';
        break;
      case JobApplication.STATUS_REVIEWED:
        chipColor = Colors.blue;
        statusText = 'تمت المراجعة';
        break;
      case JobApplication.STATUS_ACCEPTED:
        chipColor = Colors.green;
        statusText = 'مقبول';
        break;
      case JobApplication.STATUS_REJECTED:
        chipColor = Colors.red;
        statusText = 'مرفوض';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'غير معروف';
    }

    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showApplicationDetails(JobApplication application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل المتقدم'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('المتقدم: ${application.userId}'),
              const SizedBox(height: 8),
              Text('تاريخ التقديم: ${_formatDate(application.appliedAt)}'),
              if (application.reviewedAt != null) ...[
                const SizedBox(height: 8),
                Text('تاريخ المراجعة: ${_formatDate(application.reviewedAt!)}'),
              ],
              const SizedBox(height: 8),
              _buildStatusChip(application.status),
              if (application.coverLetter != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'خطاب التقديم:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(application.coverLetter!),
              ],
              if (application.attachments != null && application.attachments!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'المرفقات:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...application.attachments!.map((url) => TextButton(
                  onPressed: () => _openAttachment(url),
                  child: Text(url),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          TextButton(
            onPressed: () {
              _updateApplicationStatus(application, JobApplication.STATUS_ACCEPTED);
              Navigator.pop(context);
            },
            child: const Text('قبول'),
          ),
          TextButton(
            onPressed: () {
              _updateApplicationStatus(application, JobApplication.STATUS_REJECTED);
              Navigator.pop(context);
            },
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }

  void _openAttachment(String url) {
    // TODO: Implement attachment viewing
    // You can use url_launcher package to open the attachment
  }

  Future<void> _updateApplicationStatus(JobApplication application, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(application.id)
          .update({
        'status': newStatus,
        'reviewedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == JobApplication.STATUS_ACCEPTED
                ? 'تم قبول المتقدم'
                : newStatus == JobApplication.STATUS_REJECTED
                    ? 'تم رفض المتقدم'
                    : 'تم تحديث الحالة'
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تحديث الحالة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildApplicantsList(),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
} 