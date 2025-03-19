import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class SkillsDialog extends StatefulWidget {
  final List<String> initialSkills;
  final Function(List<String>) onSave;

  const SkillsDialog({
    super.key,
    required this.initialSkills,
    required this.onSave,
  });

  @override
  State<SkillsDialog> createState() => _SkillsDialogState();
}

class _SkillsDialogState extends State<SkillsDialog> {
  late List<String> _skills;
  final TextEditingController _skillController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _skills = List.from(widget.initialSkills);
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'المهارات',
      onSave: _isLoading ? null : _handleSave,
      child: Column(
        children: [
          // Add Skill Input Field
          Row(
            children: [
              // Add Button
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF4CA6A8)),
                onPressed: () {
                  _addSkill();
                },
              ),
              const SizedBox(width: 8),
              
              // Text Field
              Expanded(
                child: TextField(
                  controller: _skillController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: 'أضف مهارة جديدة',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addSkill(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Skills List
          if (_skills.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'لم تضف أي مهارات بعد',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: _skills.map((skill) => _buildSkillChip(skill)).toList(),
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

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: const Color(0xFFE6F4F1),
      labelStyle: const TextStyle(color: Color(0xFF4CA6A8)),
      deleteIcon: const Icon(Icons.close, size: 18, color: Color(0xFF4CA6A8)),
      onDeleted: () {
        setState(() {
          _skills.remove(skill);
        });
      },
    );
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await widget.onSave(_skills);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }
} 