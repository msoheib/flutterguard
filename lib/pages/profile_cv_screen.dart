import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';
import '../widgets/profile/about_dialog.dart' as profile_dialog;

class ProfileCvScreen extends StatefulWidget {
  const ProfileCvScreen({super.key});

  @override
  State<ProfileCvScreen> createState() => _ProfileCvScreenState();
}

class _ProfileCvScreenState extends State<ProfileCvScreen> {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileService.getProfile();
      setState(() {
        _profile = profile;
      });
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with back button and title
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 375,
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 44),
                        const Text(
                          'الملف الشخصي',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 20,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF4CA6A8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Transform.rotate(
                              angle: 3.14159,
                              child: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Profile Banner
            Container(
              margin: const EdgeInsets.fromLTRB(28, 20, 28, 20),
              width: 319,
              height: 121,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF4CA6A8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _profile?.name ?? 'جاري التحميل...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _profile?.title ?? 'حارس أمن',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Profile Image with Edit Button
                  Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 71,
                            height: 71,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC4C4C4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (_profile?.photoUrl != null && _profile!.photoUrl!.isNotEmpty)
                            Container(
                              width: 71,
                              height: 71,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(_profile!.photoUrl!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Edit Button below profile picture
                      Container(
                        width: 29,
                        height: 30,
                        padding: const EdgeInsets.all(6),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Color(0xFF4CA6A8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  _buildSection(
                    title: 'معلومات عنك',
                    icon: 'about.svg',
                    onTap: () => _handleSectionTap('about', _profile),
                  ),
                  _buildSection(
                    title: 'خبراتك في العمل',
                    icon: 'experience.svg',
                    onTap: () => _handleSectionTap('experience', _profile),
                  ),
                  _buildSection(
                    title: 'التعليم',
                    icon: 'education.svg',
                    onTap: () => _handleSectionTap('education', _profile),
                  ),
                  _buildSection(
                    title: 'المهارات',
                    icon: 'skills.svg',
                    onTap: () => _handleSectionTap('skills', _profile),
                  ),
                  _buildSection(
                    title: 'اللغات',
                    icon: 'languages.svg',
                    onTap: () => _handleSectionTap('languages', _profile),
                  ),
                  _buildSection(
                    title: 'الشهادات',
                    icon: 'certificates.svg',
                    onTap: () => _handleSectionTap('certificates', _profile),
                  ),
                ],
              ),
            ),

            // Home Indicator
            Container(
              width: 375,
              height: 34,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(121, 21, 120, 8),
              child: Container(
                width: 134,
                height: 5,
                decoration: ShapeDecoration(
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF4CA6A8).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: Color(0xFF4CA6A8),
              ),
            ),
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/media/icons/$icon',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSectionTap(String section, Profile? profile) {
    switch (section) {
      case 'about':
        showDialog(
          context: context,
          builder: (context) => profile_dialog.AboutDialog(
            initialAbout: profile?.about ?? '',
            onSave: (value) => _profileService.updateAbout(value),
          ),
        );
        break;
      case 'experience':
        // Show experience dialog
        break;
      case 'education':
        // Show education dialog
        break;
      // ... handle other sections
    }
  }
}