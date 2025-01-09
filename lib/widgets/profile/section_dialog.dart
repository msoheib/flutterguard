import 'package:flutter/material.dart';

class SectionDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onSave;

  const SectionDialog({
    super.key,
    required this.title,
    required this.child,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 16,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onSave != null)
                  TextButton(
                    onPressed: onSave,
                    child: const Text('حفظ'),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
} 