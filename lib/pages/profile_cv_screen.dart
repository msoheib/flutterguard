import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/profile/work_experience_dialog.dart';
import '../widgets/profile/education_dialog.dart';
import '../widgets/profile/skills_dialog.dart';
import '../widgets/profile/languages_dialog.dart';
import '../widgets/profile/certificates_dialog.dart';
import '../widgets/profile/personal_info_dialog.dart';

class ProfileCvScreen extends StatefulWidget {
  const ProfileCvScreen({super.key});

  @override
  State<ProfileCvScreen> createState() => _ProfileCvScreenState();
}

class _ProfileCvScreenState extends State<ProfileCvScreen> {
  final ProfileService _profileService = ProfileService();
  Profile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      // Get current user's profile
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }
      
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (!doc.exists) {
        // Create a default profile
        final defaultProfile = Profile(
          id: userId,
          personalInfo: PersonalInfo(
            name: FirebaseAuth.instance.currentUser?.displayName ?? 'مستخدم جديد',
            profession: 'حارس أمن',
            about: 'أدخل نبذة عنك هنا',
          ),
          languages: [],
          certificates: [],
        );
        
        setState(() {
          _profile = defaultProfile;
          _isLoading = false;
        });
        return;
      }
      
      final profile = Profile.fromFirestore(doc);
      
      // If personalInfo is null, create a default one
      if (profile.personalInfo == null) {
        final updatedProfile = profile.copyWith(
          personalInfo: PersonalInfo(
            name: FirebaseAuth.instance.currentUser?.displayName ?? 'مستخدم جديد',
            profession: 'حارس أمن',
            about: 'أدخل نبذة عنك هنا',
          ),
        );
        
        setState(() {
          _profile = updatedProfile;
          _isLoading = false;
        });
      } else {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  // Get personalInfo safely to avoid null errors
  PersonalInfo get _personalInfo {
    return _profile?.personalInfo ?? 
      PersonalInfo(
        name: 'مستخدم جديد', 
        profession: 'حارس أمن', 
        about: 'أدخل نبذة عنك هنا'
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with title and back button based on Figma
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              child: Stack(
                children: [
                  // Background container
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
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
                    ),
                  ),
                  
                  // Title and back button container
                  Positioned(
                    right: 28,
                    top: 70,
                    child: Container(
                      width: 319,
                      height: 44,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Placeholder for left side to ensure proper spacing
                          const SizedBox(width: 44),
                          
                          // Title
                          const Text(
                            'الملف الشخصي',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 20,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                              height: 1.40,
                            ),
                          ),
                          
                          // Back button
                          GestureDetector(
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
                  
                  // Status bar area (top part of the screen)
                  SafeArea(
                    child: Container(
                      height: 44,
                      // Status bar content is automatically rendered by the system
                    ),
                  ),
                ],
              ),
            ),

            // Profile Banner
            Container(
              margin: const EdgeInsets.fromLTRB(28, 20, 28, 20),
              width: 319,
              height: 121,
              decoration: BoxDecoration(
                color: const Color(0xFF4CA6A8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  // Profile information and avatar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Profile information (right side for RTL)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _personalInfo.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _personalInfo.profession,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Profile Image
                        Container(
                          width: 71,
                          height: 71,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC4C4C4),
                            shape: BoxShape.circle,
                            image: _profile?.photoUrl != null && _profile!.photoUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(_profile!.photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profile?.photoUrl == null || _profile!.photoUrl!.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  
                  // Edit button positioned at the bottom right of profile banner
                  Positioned(
                    right: 16 + 35, // Center under the profile image
                    bottom: 10,
                    child: GestureDetector(
                      onTap: () {
                        // Add your edit profile logic here
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: Color(0xFF4CA6A8),
                          ),
                        ),
                      ),
                    ),
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
    // Directly determine the icon to display
    Widget iconWidget;
    Color iconColor = const Color(0xFF4CA6A8);
    
    // Set icons for all sections
    if (icon == 'about.svg') {
      iconWidget = Icon(Icons.person_outline, size: 20, color: iconColor);
    } else if (icon == 'experience.svg') {
      iconWidget = Icon(Icons.work_outline, size: 20, color: iconColor);
    } else if (icon == 'education.svg') {
      iconWidget = Icon(Icons.school_outlined, size: 20, color: iconColor);
    } else if (icon == 'skills.svg') {
      iconWidget = Icon(Icons.star_outline, size: 20, color: iconColor);
    } else if (icon == 'languages.svg') {
      iconWidget = Icon(Icons.translate_outlined, size: 20, color: iconColor);
    } else if (icon == 'certificates.svg') {
      iconWidget = Icon(Icons.workspace_premium_outlined, size: 20, color: iconColor);
    } else {
      iconWidget = Icon(Icons.info_outline, size: 20, color: iconColor);
    }

    // Check if section has data to show badge
    bool hasData = false;
    if (icon == 'about.svg') {
      hasData = _personalInfo.about.isNotEmpty;
    } else if (icon == 'experience.svg') {
      hasData = _profile?.getWorkExperiences.isNotEmpty ?? false;
    } else if (icon == 'education.svg') {
      hasData = _profile?.getEducation.isNotEmpty ?? false;
    } else if (icon == 'skills.svg') {
      hasData = _profile?.getSkills.isNotEmpty ?? false;
    } else if (icon == 'languages.svg') {
      hasData = _profile?.getLanguages.isNotEmpty ?? false;
    } else if (icon == 'certificates.svg') {
      hasData = _profile?.getCertificates.isNotEmpty ?? false;
    }

    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Directionality(
            textDirection: TextDirection.rtl, // Ensure RTL layout
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Right side in RTL: Icon and Title
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon first (on the right in RTL)
                    iconWidget,
                    const SizedBox(width: 8),
                    
                    // Title text
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (hasData) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CA6A8),
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  ],
                ),
                
                // Left side in RTL: Add button
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF9FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      hasData ? Icons.edit : Icons.add,
                      color: const Color(0xFF4CA6A8),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSectionTap(String section, Profile? profile) {
    switch (section) {
      case 'about':
        showDialog(
          context: context,
          builder: (context) => PersonalInfoDialog(
            initialInfo: _personalInfo,
            onSave: (info) async {
              if (profile != null) {
                await _profileService.updatePersonalInfo(info);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
      case 'experience':
        showDialog(
          context: context,
          builder: (context) => WorkExperienceDialog(
            onSave: (experience) async {
              if (profile != null) {
                await _profileService.saveWorkExperience(experience);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
      case 'education':
        showDialog(
          context: context,
          builder: (context) => EducationDialog(
            onSave: (education) async {
              if (profile != null) {
                await _profileService.saveEducation(education);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
      case 'skills':
        showDialog(
          context: context,
          builder: (context) => SkillsDialog(
            initialSkills: profile?.getSkills ?? [],
            onSave: (skills) async {
              if (profile != null) {
                await _profileService.updateSkills(skills);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
      case 'languages':
        showDialog(
          context: context,
          builder: (context) => LanguagesDialog(
            initialLanguages: profile?.getLanguages ?? [],
            onSave: (languages) async {
              if (profile != null) {
                await _profileService.updateLanguages(languages);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
      case 'certificates':
        showDialog(
          context: context,
          builder: (context) => CertificatesDialog(
            initialCertificates: profile?.getCertificates ?? [],
            onSave: (certificates) async {
              if (profile != null) {
                await _profileService.updateCertificates(certificates);
                _loadProfile(); // Reload profile
              }
            },
          ),
        );
        break;
    }
  }
}