import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/common/app_header.dart';
import '../widgets/authenticated_layout.dart';
import '../services/support_service.dart';
import '../services/service_locator.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportService = getIt<SupportService>();

    return AuthenticatedLayout(
      currentIndex: 0,
      child: Column(
        children: [
          const AppHeader(
            title: 'الدعم الفني',
            showBackButton: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildContactOption(
                  context: context,
                  title: 'المحادثة المباشرة',
                  subtitle: 'تحدث مع أحد ممثلي خدمة العملاء',
                  icon: 'assets/media/icons/Chat.svg',
                  onTap: () => supportService.startLiveChat(),
                ),
                _buildContactOption(
                  context: context,
                  title: 'البريد الإلكتروني',
                  subtitle: 'support@example.com',
                  icon: 'assets/media/icons/email.svg',
                  onTap: () => supportService.sendEmail(),
                ),
                _buildContactOption(
                  context: context,
                  title: 'الهاتف',
                  subtitle: '+966 XX XXX XXXX',
                  icon: 'assets/media/icons/phone.svg',
                  onTap: () => supportService.makePhoneCall(),
                ),
                _buildContactOption(
                  context: context,
                  title: 'الأسئلة الشائعة',
                  subtitle: 'اطلع على الأسئلة المتكررة',
                  icon: 'assets/media/icons/faq.svg',
                  onTap: () {
                    Navigator.pushNamed(context, '/faq');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
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
      child: ListTile(
        onTap: onTap,
        leading: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
          color: const Color(0xFF4CA6A8),
        ),
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
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
} 