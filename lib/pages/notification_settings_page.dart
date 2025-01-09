import 'package:flutter/material.dart';
import '../widgets/common/app_header.dart';
import '../widgets/authenticated_layout.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _newJobsNotifications = true;
  bool _applicationUpdates = true;
  bool _chatMessages = true;

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 0,
      child: Column(
        children: [
          const AppHeader(
            title: 'إعدادات الإشعارات',
            showBackButton: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildNotificationToggle(
                  title: 'الوظائف الجديدة',
                  subtitle: 'إشعارات عن الوظائف الجديدة المتاحة',
                  value: _newJobsNotifications,
                  onChanged: (value) {
                    setState(() => _newJobsNotifications = value);
                  },
                ),
                _buildNotificationToggle(
                  title: 'تحديثات الطلبات',
                  subtitle: 'إشعارات عن حالة طلبات التوظيف',
                  value: _applicationUpdates,
                  onChanged: (value) {
                    setState(() => _applicationUpdates = value);
                  },
                ),
                _buildNotificationToggle(
                  title: 'الرسائل',
                  subtitle: 'إشعارات عن الرسائل الجديدة',
                  value: _chatMessages,
                  onChanged: (value) {
                    setState(() => _chatMessages = value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 16,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
        ),
        activeColor: const Color(0xFF4CA6A8),
      ),
    );
  }
} 