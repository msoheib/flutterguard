import 'package:flutter/material.dart';
import '../../widgets/common/app_header.dart';
import '../../services/admin_service.dart';

class SupportDashboard extends StatelessWidget {
  final AdminService _adminService = getIt<AdminService>();

  SupportDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(
            title: 'لوحة الدعم الفني',
            showBackButton: true,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _adminService.getSupportTickets(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tickets = snapshot.data!;
                return ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(context, ticket);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Map<String, dynamic> ticket) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('تذكرة #${ticket['id'].substring(0, 8)}'),
        subtitle: Text(
          'الحالة: ${_getStatusText(ticket['status'])}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/admin/ticket-detail',
              arguments: ticket['id'],
            );
          },
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'في الانتظار';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }
} 