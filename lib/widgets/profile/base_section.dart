import 'package:flutter/material.dart';

class BaseSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isEditing;
  final VoidCallback? onEdit;

  const BaseSection({
    super.key,
    required this.title,
    required this.child,
    required this.isEditing,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isEditing && onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CA6A8).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16),
                  ),
                ),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
} 