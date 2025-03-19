import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class PersonalInfoDialog extends StatefulWidget {
  final PersonalInfo? initialInfo;
  final Function(PersonalInfo) onSave;

  const PersonalInfoDialog({
    super.key,
    this.initialInfo,
    required this.onSave,
  });

  @override
  State<PersonalInfoDialog> createState() => _PersonalInfoDialogState();
}

class _PersonalInfoDialogState extends State<PersonalInfoDialog> {
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _aboutController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialInfo?.name ?? '');
    _professionController = TextEditingController(text: widget.initialInfo?.profession ?? '');
    _aboutController = TextEditingController(text: widget.initialInfo?.about ?? '');
    _locationController = TextEditingController(text: widget.initialInfo?.location ?? '');
    _phoneController = TextEditingController(text: widget.initialInfo?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'المعلومات الشخصية',
      onSave: _isLoading ? null : _handleSave,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال الاسم';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Profession
            TextFormField(
              controller: _professionController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'المهنة',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال المهنة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // About
            TextFormField(
              controller: _aboutController,
              textAlign: TextAlign.right,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'نبذة عني',
                hintText: 'اكتب نبذة مختصرة عن نفسك وخبراتك',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال نبذة عنك';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'الموقع',
                hintText: 'المدينة، البلد',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Phone
            TextFormField(
              controller: _phoneController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                hintText: '+966 12 345 6789',
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

  Future<void> _handleSave() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final updatedInfo = PersonalInfo(
        name: _nameController.text,
        profession: _professionController.text,
        about: _aboutController.text,
        location: _locationController.text,
        phone: _phoneController.text,
      );
      
      await widget.onSave(updatedInfo);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
} 