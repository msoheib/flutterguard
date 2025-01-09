import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  final bool isEditing;

  const ProfileHeaderSection({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Profile picture
          Container(
            width: 71,
            height: 71,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFC4C4C4),
            ),
            child: isEditing
                ? IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // Handle image upload
                    },
                  )
                : null,
          ),
          const SizedBox(height: 16),
          // Name
          isEditing
              ? TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'الاسم',
                  ),
                )
              : const Text(
                  'عبدالله فؤاد سعيد سالم',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
          const SizedBox(height: 8),
          // Title
          isEditing
              ? TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'المسمى الوظيفي',
                  ),
                )
              : const Text(
                  'حارس أمن',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
} 