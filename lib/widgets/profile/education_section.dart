import 'package:flutter/material.dart';
import 'base_section.dart';

class EducationSection extends StatelessWidget {
  final bool isEditing;

  const EducationSection({
    super.key,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSection(
      title: 'التعليم',
      isEditing: isEditing,
      onEdit: isEditing ? () {} : null,
      child: Column(
        children: [
          _buildEducationItem(),
          if (isEditing) _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildEducationItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'حارس أمن',
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'جامعة الملك فيصل',
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jan 2015 - Feb 2022',
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 12,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildAttachmentBox(),
              const SizedBox(width: 16),
              _buildAttachmentBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentBox() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAddButton() {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, color: Color(0xFF4CA6A8)),
      label: const Text(
        'إضافة شهادة',
        style: TextStyle(
          color: Color(0xFF4CA6A8),
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
} 