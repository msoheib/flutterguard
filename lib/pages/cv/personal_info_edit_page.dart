import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../util/snackbar_util.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';

class PersonalInfoEditPage extends StatefulWidget {
  final PersonalInfo initialInfo;

  const PersonalInfoEditPage({
    super.key,
    required this.initialInfo,
  });

  @override
  State<PersonalInfoEditPage> createState() => _PersonalInfoEditPageState();
}

class _PersonalInfoEditPageState extends State<PersonalInfoEditPage> {
  final ProfileService _profileService = ProfileService();
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _aboutController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  
  // Add focus nodes for all text fields
  late FocusNode _nameFocusNode;
  late FocusNode _professionFocusNode;
  late FocusNode _aboutFocusNode;
  late FocusNode _locationFocusNode;
  late FocusNode _phoneFocusNode;
  
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialInfo.name);
    _professionController = TextEditingController(text: widget.initialInfo.profession);
    _aboutController = TextEditingController(text: widget.initialInfo.about);
    _locationController = TextEditingController(text: widget.initialInfo.location);
    _phoneController = TextEditingController(text: widget.initialInfo.phone);
    
    // Initialize focus nodes
    _nameFocusNode = FocusNode();
    _professionFocusNode = FocusNode();
    _aboutFocusNode = FocusNode();
    _locationFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    
    // Dispose focus nodes
    _nameFocusNode.dispose();
    _professionFocusNode.dispose();
    _aboutFocusNode.dispose();
    _locationFocusNode.dispose();
    _phoneFocusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'تعديل المعلومات الشخصية',
        showBackButton: true,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Name
                    _buildTextField(
                      label: 'الاسم',
                      hint: 'أدخل اسمك',
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال الاسم' : null,
                    ),
                    const SizedBox(height: 24),

                    // Profession
                    _buildTextField(
                      label: 'المهنة',
                      hint: 'أدخل مهنتك',
                      controller: _professionController,
                      focusNode: _professionFocusNode,
                      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال المهنة' : null,
                    ),
                    const SizedBox(height: 24),

                    // About
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'نبذة عنك',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: TextFormField(
                                    controller: _aboutController,
                                    focusNode: _aboutFocusNode,
                                    textAlign: TextAlign.right,
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: _aboutFocusNode.hasFocus || _aboutController.text.isNotEmpty ? '' : 'اكتب نبذة عنك',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF6A6A6A),
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(12),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onTap: () {
                                      // Force rebuild when focused to update hint text
                                      setState(() {});
                                    },
                                    onChanged: (value) {
                                      // Force rebuild when text changes to update hint text
                                      setState(() {});
                                    },
                                    validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال نبذة عنك' : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Location
                    _buildTextField(
                      label: 'الموقع',
                      hint: 'أدخل موقعك',
                      controller: _locationController,
                      focusNode: _locationFocusNode,
                      validator: null, // Optional
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 24),

                    // Phone
                    _buildTextField(
                      label: 'رقم الهاتف',
                      hint: 'أدخل رقم هاتفك',
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      validator: null, // Optional
                      prefixIcon: Icons.phone,
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    GestureDetector(
                      onTap: _handleSave,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CA6A8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'حفظ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: focusNode.hasFocus || controller.text.isNotEmpty ? '' : hint,
                              hintStyle: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xFF4CA6A8)) : null,
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onTap: () {
                              // Force rebuild when focused to update hint text
                              setState(() {});
                            },
                            onChanged: (value) {
                              // Force rebuild when text changes to update hint text
                              setState(() {});
                            },
                            validator: validator,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final personalInfo = PersonalInfo(
        name: _nameController.text,
        profession: _professionController.text,
        about: _aboutController.text,
        location: _locationController.text,
        phone: _phoneController.text,
      );
      
      await _profileService.updatePersonalInfo(personalInfo);
      if (mounted) {
        showSnackBar(context, 'تم تحديث المعلومات الشخصية بنجاح');
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ أثناء حفظ المعلومات الشخصية');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
} 