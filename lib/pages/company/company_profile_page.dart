import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/city_service.dart';
import '../../util/snackbar_util.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isEditing = false;
  
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

  final CityService _cityService = CityService();

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadCompanyProfile();
  }
  
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

  Future<void> _loadCities() async {
    try {
      await _cityService.initializeCities();
    } catch (e) {
      print('Error loading cities: $e');
    }
  }

  Future<void> _loadCompanyProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
      if (!docSnapshot.exists) throw Exception('User profile not found');

      final data = docSnapshot.data();
      final companyInfo = data?['profile']?['companyInfo'];

      if (companyInfo != null) {
        setState(() {
          _nameController.text = companyInfo['name'] ?? '';
          _descriptionController.text = companyInfo['description'] ?? '';
          _websiteController.text = companyInfo['website'] ?? '';
          _establishedYearController.text = companyInfo['foundedYear']?.toString() ?? '';
          _registrationNumberController.text = companyInfo['registrationNumber'] ?? '';
          _selectedIndustry = companyInfo['industry'];
          _selectedSize = companyInfo['size'];
          
          if (companyInfo['address'] != null) {
            _streetController.text = companyInfo['address']['street'] ?? '';
            _buildingController.text = companyInfo['address']['building'] ?? '';
            _selectedCity = companyInfo['address']['city'];
            _postalCodeController.text = companyInfo['address']['postalCode'] ?? '';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showErrorSnackbar(context, 'Error loading profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _firestore.collection('users').doc(user.uid).update({
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
        SnackbarUtil.showSuccessSnackbar(context, 'تم تحديث الملف الشخصي بنجاح');
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showErrorSnackbar(context, 'Error saving profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCityDropdown() {
    return StreamBuilder<List<String>>(
      stream: _cityService.getCities(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cities = snapshot.data!;
        
        // Check if the selected city exists in the list
        bool cityExists = false;
        if (_selectedCity != null) {
          cityExists = cities.contains(_selectedCity);
        }
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'المدينة',
              alignLabelWithHint: true,
            ),
            value: cityExists ? _selectedCity : null,
            onChanged: _isEditing ? (value) => setState(() => _selectedCity = value) : null,
            items: cities.map((city) => DropdownMenuItem(
              value: city,
              child: Text(city),
            )).toList(),
            validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
            isExpanded: true,
            hint: const Text('اختر المدينة'),
          ),
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?)? onChanged,
    required String? Function(String?)? validator,
  }) {
    // Check if the value exists in the items
    bool valueExists = false;
    if (value != null) {
      valueExists = items.any((item) => item.value == value);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          alignLabelWithHint: true,
        ),
        value: valueExists ? value : null,
        onChanged: _isEditing ? onChanged : null,
        items: items,
        validator: validator,
        isExpanded: true,
        hint: Text('اختر $label'),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          alignLabelWithHint: true,
        ),
        validator: validator,
        enabled: _isEditing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'الملف الشخصي للشركة',
        showBackButton: true,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 20),
                      
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
                      
                      // Edit or Save button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_isEditing) {
                              _saveProfile();
                            } else {
                              setState(() {
                                _isEditing = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CA6A8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            _isEditing ? 'حفظ التغييرات' : 'تعديل الملف',
                            style: const TextStyle(
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
} 