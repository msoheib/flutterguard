import 'package:flutter/material.dart';
import '../services/city_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyProfileSetupPage extends StatefulWidget {
  const CompanyProfileSetupPage({super.key});

  @override
  State<CompanyProfileSetupPage> createState() => _CompanyProfileSetupPageState();
}

class _CompanyProfileSetupPageState extends State<CompanyProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _websiteController = TextEditingController();
  final _establishedYearController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  String? _selectedIndustry;
  String? _selectedSize;
  String? _selectedCity;
  
  final List<String> _industries = [
    'Security Services',
    'Private Security',
    'Security Systems',
    'Security Consulting',
    'Other'
  ];
  
  final List<String> _companySizes = [
    '1-10',
    '11-50',
    '51-200',
    '201-500',
    '500+'
  ];
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _establishedYearController.dispose();
    _registrationNumberController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  final CityService _cityService = CityService();
  bool _acceptedTerms = false;
  final List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    await _cityService.initializeCities();
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          alignment: AlignmentDirectional.centerEnd,
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return StreamBuilder<List<String>>(
      stream: _cityService.getCities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final cities = snapshot.data!;
        
        return _buildDropdownField<String>(
          label: 'المدينة',
          value: _selectedCity,
          items: cities.map((city) => DropdownMenuItem(
            value: city,
            child: Text(city),
          )).toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
        );
      },
    );
  }

  Widget _buildIndustryDropdown() {
    return SizedBox(
      height: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'القطاع الصناعي',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedIndustry,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
              hint: const Text(
                'اختر القطاع',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: _industries.map((industry) {
                return DropdownMenuItem<String>(
                  value: industry,
                  child: Text(
                    industry,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIndustry = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء اختيار القطاع';
                }
                return null;
              },
              isExpanded: true,
              alignment: AlignmentDirectional.centerEnd,
              icon: const Icon(Icons.keyboard_arrow_down),
              dropdownColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsUpload() {
    return SizedBox(
      height: 114,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'المستندات الرسمية (مثل السجل التجاري أو رخصة العمل)',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 92,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFCBD5E1),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload_file, color: Color(0xFF6A6A6A)),
                  onPressed: () {
                    // TODO: Implement file upload
                  },
                ),
                const Text(
                  'ارفع المستندات الرسمية للشركة للتحقق',
                  style: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 70),
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'إنشاء الحساب',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF1A1D1E),
                          fontSize: 30,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'املأ التفاصيل الخاصة بالشركة المراد اضافتها \nفي التطبيق',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildFormField(
                  label: 'اسم الشركة',
                  controller: _nameController,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'وصف الشركة',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'مجال العمل',
                  value: _selectedIndustry,
                  items: _industries.map((industry) => DropdownMenuItem(
                    value: industry,
                    child: Text(industry),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedIndustry = value),
                  validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'حجم الشركة',
                  value: _selectedSize,
                  items: _companySizes.map((size) => DropdownMenuItem(
                    value: size,
                    child: Text(size),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedSize = value),
                  validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'الموقع الإلكتروني',
                  controller: _websiteController,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'سنة التأسيس',
                  controller: _establishedYearController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'رقم السجل التجاري',
                  controller: _registrationNumberController,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildCityDropdown(),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'الشارع',
                  controller: _streetController,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'المبنى',
                  controller: _buildingController,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  label: 'الرمز البريدي',
                  controller: _postalCodeController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
                ),
                const SizedBox(height: 24),
                _buildDocumentsUpload(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'الموافقة على شروط سياسية الخصوصية',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF4CA6A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: TextButton(
                    onPressed: _saveProfile,
                    child: const Text(
                      'التقديم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isProfileComplete': true,
        'profile.companyInfo': {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'website': _websiteController.text,
          'industry': _selectedIndustry,
          'size': _selectedSize,
          'foundedYear': _establishedYearController.text,
          'registrationNumber': _registrationNumberController.text,
          'address': {
            'street': _streetController.text,
            'building': _buildingController.text,
            'city': _selectedCity,
            'postalCode': _postalCodeController.text,
          },
        },
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/company/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 