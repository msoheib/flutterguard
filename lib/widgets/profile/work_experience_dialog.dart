import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class WorkExperienceDialog extends StatefulWidget {
  final WorkExperience? initialExperience;
  final Function(WorkExperience) onSave;

  const WorkExperienceDialog({
    super.key,
    this.initialExperience,
    required this.onSave,
  });

  @override
  State<WorkExperienceDialog> createState() => _WorkExperienceDialogState();
}

class _WorkExperienceDialogState extends State<WorkExperienceDialog> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;
  bool _isCurrentJob = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.initialExperience?.jobTitle ?? '');
    _companyController = TextEditingController(text: widget.initialExperience?.company ?? '');
    _startDateController = TextEditingController(text: widget.initialExperience?.startDate ?? '');
    _endDateController = TextEditingController(text: widget.initialExperience?.endDate ?? '');
    _isCurrentJob = widget.initialExperience?.endDate == null;
    _descriptionController = TextEditingController(text: widget.initialExperience?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'الخبرة العملية',
      onSave: _isLoading ? null : _handleSave,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Job Title
            TextFormField(
              controller: _jobTitleController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'المسمى الوظيفي',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال المسمى الوظيفي';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Company
            TextFormField(
              controller: _companyController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'الشركة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم الشركة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Dates - Start and End
            Row(
              children: [
                // End Date
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'تاريخ الإنتهاء',
                      hintText: 'يناير 2023',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (!_isCurrentJob && (value == null || value.isEmpty)) {
                        return 'مطلوب';
                      }
                      return null;
                    },
                    enabled: !_isCurrentJob,
                    onTap: _isCurrentJob ? null : () => _selectDate(_endDateController),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Start Date
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: 'تاريخ البدء',
                      hintText: 'يناير 2022',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'مطلوب';
                      }
                      return null;
                    },
                    onTap: () => _selectDate(_startDateController),
                  ),
                ),
              ],
            ),
            
            // Current Job Checkbox
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('أعمل حاليًا في هذه الوظيفة'),
                  Checkbox(
                    value: _isCurrentJob,
                    activeColor: const Color(0xFF4CA6A8),
                    onChanged: (value) {
                      setState(() {
                        _isCurrentJob = value ?? false;
                        if (_isCurrentJob) {
                          _endDateController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              textAlign: TextAlign.right,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                hintText: 'اكتب وصفًا مختصرًا لمسؤولياتك وإنجازاتك',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال وصف للوظيفة';
                }
                return null;
              },
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

  Future<void> _selectDate(TextEditingController controller) async {
    final initialDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      // Format the date as Month Year (e.g., "يناير 2022")
      final String month = _getArabicMonth(pickedDate.month);
      final String formattedDate = '$month ${pickedDate.year}';
      controller.text = formattedDate;
    }
  }
  
  String _getArabicMonth(int month) {
    switch (month) {
      case 1: return 'يناير';
      case 2: return 'فبراير';
      case 3: return 'مارس';
      case 4: return 'أبريل';
      case 5: return 'مايو';
      case 6: return 'يونيو';
      case 7: return 'يوليو';
      case 8: return 'أغسطس';
      case 9: return 'سبتمبر';
      case 10: return 'أكتوبر';
      case 11: return 'نوفمبر';
      case 12: return 'ديسمبر';
      default: return '';
    }
  }

  Future<void> _handleSave() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final experience = WorkExperience(
        jobTitle: _jobTitleController.text,
        company: _companyController.text,
        startDate: _startDateController.text,
        endDate: _isCurrentJob ? null : _endDateController.text,
        description: _descriptionController.text,
        id: widget.initialExperience?.id,
      );
      
      await widget.onSave(experience);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 