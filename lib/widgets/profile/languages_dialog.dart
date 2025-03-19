import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class LanguagesDialog extends StatefulWidget {
  final List<Language> initialLanguages;
  final Function(List<Language>) onSave;

  const LanguagesDialog({
    super.key,
    required this.initialLanguages,
    required this.onSave,
  });

  @override
  State<LanguagesDialog> createState() => _LanguagesDialogState();
}

class _LanguagesDialogState extends State<LanguagesDialog> {
  late List<Language> _languages;
  final TextEditingController _nameController = TextEditingController();
  String _selectedProficiency = 'متوسط'; // Default proficiency
  final List<String> _proficiencyLevels = ['مبتدئ', 'متوسط', 'متقدم', 'طلاقة'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _languages = List.from(widget.initialLanguages);
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'اللغات',
      onSave: _isLoading ? null : _handleSave,
      child: Column(
        children: [
          // Add Language Section
          Row(
            children: [
              // Add Button
              IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF4CA6A8)),
                onPressed: () {
                  _addLanguage();
                },
              ),
              const SizedBox(width: 8),
              
              // Proficiency Dropdown
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _selectedProficiency,
                  decoration: const InputDecoration(
                    labelText: 'المستوى',
                    border: OutlineInputBorder(),
                  ),
                  items: _proficiencyLevels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level, textAlign: TextAlign.right),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedProficiency = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              
              // Language Name TextField
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'اللغة',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // List of Languages
          if (_languages.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'لا توجد لغات مضافة',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      language.name,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      language.proficiency,
                      textAlign: TextAlign.right,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeLanguage(index);
                      },
                    ),
                  ),
                );
              },
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

  void _addLanguage() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    
    setState(() {
      _languages.add(Language(
        name: name,
        proficiency: _selectedProficiency,
      ));
      _nameController.clear();
      _selectedProficiency = 'متوسط'; // Reset to default
    });
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
    });
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      await widget.onSave(_languages);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
} 