import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../util/snackbar_util.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';

class WorkExperienceEditPage extends StatefulWidget {
  final WorkExperience? initialExperience;

  const WorkExperienceEditPage({
    super.key,
    this.initialExperience,
  });

  @override
  State<WorkExperienceEditPage> createState() => _WorkExperienceEditPageState();
}

class _WorkExperienceEditPageState extends State<WorkExperienceEditPage> {
  final ProfileService _profileService = ProfileService();
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;
  
  // Add focus nodes for text fields
  late FocusNode _jobTitleFocusNode;
  late FocusNode _companyFocusNode;
  late FocusNode _descriptionFocusNode;
  
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
    
    // Initialize focus nodes
    _jobTitleFocusNode = FocusNode();
    _companyFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    
    // Dispose focus nodes
    _jobTitleFocusNode.dispose();
    _companyFocusNode.dispose();
    _descriptionFocusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.initialExperience == null ? 'إضافة خبرة عملية' : 'تعديل الخبرة العملية',
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
                    // Job Title
                    _buildTextField(
                      label: 'عنوان الوظيفة',
                      hint: 'عنوان الوظيفة',
                      controller: _jobTitleController,
                      focusNode: _jobTitleFocusNode,
                      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال عنوان الوظيفة' : null,
                    ),
                    const SizedBox(height: 24),

                    // Company Name
                    _buildTextField(
                      label: 'أسم الشركة',
                      hint: 'أسم الشركة',
                      controller: _companyController,
                      focusNode: _companyFocusNode,
                      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال اسم الشركة' : null,
                    ),
                    const SizedBox(height: 24),

                    // Date Fields
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Date Fields Row
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // End Date
                              Container(
                                width: (MediaQuery.of(context).size.width - 40) / 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'تاريخ الانتهاء',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFF1A1D1E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: _isCurrentJob ? null : () => _selectDate(_endDateController),
                                      child: Container(
                                        width: double.infinity,
                                        height: 54,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                        decoration: BoxDecoration(
                                          color: _isCurrentJob ? Colors.grey.shade200 : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _isCurrentJob ? 'حتى الآن' : (_endDateController.text.isEmpty ? 'اختر تاريخ' : _endDateController.text),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: _endDateController.text.isEmpty ? Color(0xFF6A6A6A) : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6A6A6A)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Start Date
                              Container(
                                width: (MediaQuery.of(context).size.width - 40) / 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'تاريخ البدء',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFF1A1D1E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () => _selectDate(_startDateController),
                                      child: Container(
                                        width: double.infinity,
                                        height: 54,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _startDateController.text.isEmpty ? 'اختر تاريخ' : _startDateController.text,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: _startDateController.text.isEmpty ? Color(0xFF6A6A6A) : Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6A6A6A)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Current job checkbox
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'اعمل هنا حاليا',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF1A1D1E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Checkbox(
                                value: _isCurrentJob,
                                activeColor: Color(0xFF4CA6A8),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
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
                                    'الوصف',
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
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    focusNode: _descriptionFocusNode,
                                    textAlign: TextAlign.right,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      hintText: _descriptionFocusNode.hasFocus || _descriptionController.text.isNotEmpty ? '' : 'اكتب الوصف هنا',
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
                                      // Force rebuild when focused
                                      setState(() {});
                                    },
                                    onChanged: (value) {
                                      // Force rebuild when text changes
                                      setState(() {});
                                    },
                                    validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال الوصف' : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Document Upload (Optional - since you mention firebase storage is commented out)
                    /*
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'أرفاق مستندات',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 92,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 92,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color(0xFFCBD5E1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload_file, size: 24, color: Color(0xFF6A6A6A)),
                                        const SizedBox(height: 12),
                                        Text(
                                          'أرفاق مستندات',
                                          style: TextStyle(
                                            color: Color(0xFF6A6A6A),
                                            fontSize: 14,
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
                    ),
                    const SizedBox(height: 24),
                    */

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
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onTap: () {
                              // Force rebuild when focused
                              setState(() {});
                            },
                            onChanged: (value) {
                              // Force rebuild when text changes
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
      // Format the date as 'MM/DD/YYYY' to match the design in the image
      final String formattedDate = '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';
      controller.text = formattedDate;
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
      
      await _profileService.saveWorkExperience(experience);
      if (mounted) {
        showSnackBar(context, widget.initialExperience == null
          ? 'تمت إضافة الخبرة العملية بنجاح'
          : 'تم تحديث الخبرة العملية بنجاح');
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ أثناء حفظ الخبرة العملية');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
} 