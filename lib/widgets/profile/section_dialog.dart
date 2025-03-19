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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dialog Title
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onSave,
                  child: const Text(
                    'حفظ',
                    style: TextStyle(
                      color: Color(0xFF4CA6A8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Dialog Content
            SingleChildScrollView(
              child: child,
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 