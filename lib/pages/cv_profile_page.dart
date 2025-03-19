import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/navigation/app_bars/custom_app_bar.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import '../widgets/profile/personal_info_dialog.dart';
import '../widgets/profile/work_experience_dialog.dart';
import '../widgets/profile/education_dialog.dart';
import '../widgets/profile/skills_dialog.dart';
import '../widgets/profile/languages_dialog.dart';
import '../util/snackbar_util.dart';
import 'cv/work_experience_edit_page.dart';
import 'cv/skills_edit_page.dart';
import 'cv/languages_edit_page.dart';
import 'cv/personal_info_edit_page.dart';

class CVProfilePage extends StatefulWidget {
  const CVProfilePage({super.key});

  @override
  State<CVProfilePage> createState() => _CVProfilePageState();
}

class _CVProfilePageState extends State<CVProfilePage> {
  final ProfileService _profileService = ProfileService();
  bool _isLoading = true;
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        showSnackBar(context, 'يرجى تسجيل الدخول لعرض الملف الشخصي');
        setState(() => _isLoading = false);
        return;
      }

      // Get the profile document from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        // Create a default profile if one doesn't exist
        final defaultProfile = Profile(
          id: userId,
          personalInfo: PersonalInfo(
            name: FirebaseAuth.instance.currentUser?.displayName ?? 'مستخدم جديد',
            profession: 'حارس أمن',
            about: 'أدخل نبذة عنك هنا',
          ),
        );
        
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          defaultProfile.toFirestore(),
        );
        
        setState(() {
          _profile = defaultProfile;
          _isLoading = false;
        });
        return;
      }
      
      // Parse the profile
      setState(() {
        _profile = Profile.fromFirestore(doc);
        _isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, 'حدث خطأ أثناء تحميل الملف الشخصي');
      setState(() => _isLoading = false);
    }
  }

  // Safe accessor for personalInfo
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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'الملف الشخصي',
        showBackButton: true,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Banner
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CA6A8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _personalInfo.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _personalInfo.profession,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile picture
                        GestureDetector(
                          onTap: () {
                            // Edit profile picture
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: _profile?.photoUrl != null 
                                      ? NetworkImage(_profile!.photoUrl!) 
                                      : const AssetImage('assets/media/icons/avatar.png') as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF4CA6A8), width: 1),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Color(0xFF4CA6A8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Menu Items
                  _buildMenuItem(
                    title: 'معلومات عنك',
                    icon: Icons.person_outline,
                    onTap: _editPersonalInfo,
                  ),
                  
                  _buildMenuItem(
                    title: 'خبراتك في العمل',
                    icon: Icons.work_outline,
                    onTap: _addWorkExperience,
                  ),
                  
                  _buildMenuItem(
                    title: 'التعليم',
                    icon: Icons.school_outlined,
                    onTap: _addEducation,
                  ),
                  
                  _buildMenuItem(
                    title: 'المهارات',
                    icon: Icons.psychology_outlined,
                    onTap: _editSkills,
                  ),
                  
                  _buildMenuItem(
                    title: 'اللغات',
                    icon: Icons.language_outlined,
                    onTap: _editLanguages,
                  ),
                  
                  _buildMenuItem(
                    title: 'الشهادات',
                    icon: Icons.bookmark_outline,
                    onTap: () {
                      // TODO: Navigate to certificates edit page
                    },
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add button
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                size: 18,
                color: Color(0xFF4CA6A8),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF4CA6A8),
            ),
          ],
        ),
      ),
    );
  }

  // Keep the existing edit methods below
  Future<void> _editPersonalInfo() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalInfoEditPage(
          initialInfo: _personalInfo,
        ),
      ),
    );
    
    if (result == true) {
      await _loadProfile(); // Reload profile
    }
  }
  
  Future<void> _addWorkExperience() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WorkExperienceEditPage(),
      ),
    );
    
    if (result == true) {
      await _loadProfile(); // Reload profile
    }
  }
  
  Future<void> _editWorkExperience(WorkExperience experience) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WorkExperienceEditPage(
          initialExperience: experience,
        ),
      ),
    );
    
    if (result == true) {
      await _loadProfile(); // Reload profile
    }
  }
  
  Future<void> _deleteWorkExperience(WorkExperience experience) async {
    try {
      if (experience.id == null) return;
      
      await _profileService.deleteWorkExperience(experience.id!);
      await _loadProfile(); // Reload profile
      if (mounted) showSnackBar(context, 'تم حذف الخبرة العملية بنجاح');
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ أثناء حذف الخبرة العملية');
    }
  }
  
  Future<void> _addEducation() async {
    await showDialog(
      context: context,
      builder: (context) => EducationDialog(
        onSave: (education) async {
          try {
            await _profileService.saveEducation(education);
            await _loadProfile(); // Reload profile
            if (mounted) showSnackBar(context, 'تمت إضافة التعليم بنجاح');
          } catch (e) {
            if (mounted) showSnackBar(context, 'حدث خطأ أثناء إضافة التعليم');
          }
        },
      ),
    );
  }
  
  Future<void> _editSkills() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SkillsEditPage(
          initialSkills: _profile?.getSkills ?? [],
        ),
      ),
    );
    
    if (result == true) {
      await _loadProfile(); // Reload profile
    }
  }

  // Add a method to edit languages
  Future<void> _editLanguages() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LanguagesEditPage(
          initialLanguages: _profile?.languages ?? [],
        ),
      ),
    );
    
    if (result == true) {
      await _loadProfile(); // Reload profile
    }
  }
} 