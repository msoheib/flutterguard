import 'package:flutter/material.dart';
import '../widgets/profile/header.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/profile/about_me_card.dart';
import '../widgets/profile/experience_card.dart';
import '../widgets/profile/education_card.dart';
import '../widgets/profile/skills_card.dart';
import '../widgets/profile/languages_card.dart';
import '../widgets/profile/certifications_card.dart';
import '../widgets/profile/home_indicator.dart';
import '../widgets/authenticated_layout.dart';

class ProfileCvScreen extends StatelessWidget {
  const ProfileCvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(),
                const ProfileCard(),
                const AboutMeCard(),
                const ExperienceCard(),
                const EducationCard(),
                const SkillsCard(),
                const LanguagesCard(),
                const CertificationsCard(),
                const SizedBox(height: 150),
                const HomeIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}