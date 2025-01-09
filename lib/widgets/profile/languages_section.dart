import 'package:flutter/material.dart';
import 'base_section.dart';

class LanguagesSection extends StatelessWidget {
  final bool isEditing;

  const LanguagesSection({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'اللغات',
      isEditing: isEditing,
      onEdit: isEditing ? () {} : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLanguageTag('العربية'),
              _buildLanguageTag('الانجليزية'),
              _buildLanguageTag('الهندية'),
              if (isEditing) _buildAddLanguageButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTag(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEditing)
            GestureDetector(
              onTap: () {
                // Handle remove language
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.close, size: 16, color: Color(0xFF6A6A6A)),
              ),
            ),
          Text(
            language,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 10,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLanguageButton() {
    return GestureDetector(
      onTap: () {
        // Handle add language
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4CA6A8)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: Color(0xFF4CA6A8)),
            SizedBox(width: 4),
            Text(
              'إضافة لغة',
              style: TextStyle(
                color: Color(0xFF4CA6A8),
                fontSize: 10,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 