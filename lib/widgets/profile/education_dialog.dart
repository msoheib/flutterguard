import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class EducationDialog extends StatefulWidget {
  final Education? initialEducation;
  final Function(Education) onSave;

  const EducationDialog({
    super.key,
    this.initialEducation,
    required this.onSave,
  });

  @override
  State<EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends State<EducationDialog> {
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _graduationYearController;
  late TextEditingController _notesController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.initialEducation?.degree ?? '');
    _institutionController = TextEditingController(text: widget.initialEducation?.institution ?? '');
    _fieldOfStudyController = TextEditingController(text: widget.initialEducation?.fieldOfStudy ?? '');
    _graduationYearController = TextEditingController(text: widget.initialEducation?.graduationYear ?? '');
    _notesController = TextEditingController(text: widget.initialEducation?.notes ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'التعليم',
      onSave: _isLoading ? null : _handleSave,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Degree
            TextFormField(
              controller: _degreeController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'الدرجة العلمية',
                hintText: 'بكالوريوس، ماجستير، إلخ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الدرجة العلمية';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Institution
            TextFormField(
              controller: _institutionController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'المؤسسة التعليمية',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم المؤسسة التعليمية';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Field of Study and Graduation Year
            Row(
              children: [
                // Graduation Year
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _graduationYearController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'سنة التخرج',
                      hintText: '2023',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'مطلوب';
                      }
                      return null;
                    },
                    onTap: _selectYear,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Field of Study
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _fieldOfStudyController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'مجال الدراسة',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال مجال الدراسة';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Notes
            TextFormField(
              controller: _notesController,
              textAlign: TextAlign.right,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                hintText: 'معلومات إضافية (اختياري)',
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
      ),
    );
  }

  Future<void> _selectYear() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CA6A8),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Just use the year for simplicity
      _graduationYearController.text = pickedDate.year.toString();
    }
  }

  Future<void> _handleSave() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final education = Education(
        degree: _degreeController.text,
        institution: _institutionController.text,
        fieldOfStudy: _fieldOfStudyController.text,
        graduationYear: _graduationYearController.text,
        notes: _notesController.text,
      );
      
      await widget.onSave(education);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _fieldOfStudyController.dispose();
    _graduationYearController.dispose();
    _notesController.dispose();
    super.dispose();
  }
} 