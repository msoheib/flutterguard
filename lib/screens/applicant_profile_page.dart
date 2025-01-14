import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          const CustomAppBar(title: 'الملف الشخصي'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  ProfileCard(),
                  AboutMeCard(),
                  ExperienceCard(),
                  EducationCard(),
                  SkillsCard(),
                  LanguagesCard(),
                  CertificationsCard(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 