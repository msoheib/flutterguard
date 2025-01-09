import 'package:flutter/material.dart';
import 'section_dialog.dart';

class AboutDialog extends StatefulWidget {
  final String initialAbout;
  final Function(String) onSave;

  const AboutDialog({
    super.key,
    required this.initialAbout,
    required this.onSave,
  });

  @override
  State<AboutDialog> createState() => _AboutDialogState();
}

class _AboutDialogState extends State<AboutDialog> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAbout);
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'معلومات عنك',
      onSave: _isLoading ? null : _handleSave,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            maxLines: 4,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              hintText: 'اكتب نبذة عنك...',
              border: OutlineInputBorder(),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onSave(_controller.text);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 