import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/profile/about_me_card.dart';
import '../widgets/profile/experience_card.dart';
import '../widgets/profile/education_card.dart';
import '../widgets/profile/skills_card.dart';
import '../widgets/profile/languages_card.dart';
import '../widgets/profile/certifications_card.dart';

class ApplicantProfilePage extends StatelessWidget {
  final String applicantId;
  
  const ApplicantProfilePage({
    super.key,
    required this.applicantId,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUserId == applicantId;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          CustomAppBar(
            title: 'الملف الشخصي',
            onBackPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileCard(isEditable: isOwner),
                  AboutMeCard(isEditable: isOwner),
                  ExperienceCard(isEditable: isOwner),
                  EducationCard(isEditable: isOwner),
                  SkillsCard(isEditable: isOwner),
                  LanguagesCard(isEditable: isOwner),
                  CertificationsCard(isEditable: isOwner),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 