import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/city_service.dart';
import '../../widgets/company_route_wrapper.dart';

class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({super.key});

  @override
  State<CompanySettingsPage> createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  final CityService _cityService = CityService();
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        
        if (userDoc.exists) {
          final companyInfo = userDoc.data()?['companyInfo'];
          if (companyInfo != null) {
            setState(() {
              _selectedCity = companyInfo['city'];
            });
          }
        }
      }
    } catch (e) {
      print('Error loading company data: $e');
    }
  }

  Future<void> _updateCompanyCity(String? city) async {
    if (city == null) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'companyInfo.city': city,
        });
        setState(() {
          _selectedCity = city;
        });
      }
    } catch (e) {
      print('Error updating company city: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'المدينة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<String>>(
                stream: _cityService.getCities(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final cities = snapshot.data!;

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCity,
                        items: cities.map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(
                            city,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        )).toList(),
                        onChanged: _updateCompanyCity,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: InputBorder.none,
                        ),
                        hint: const Text(
                          'اختر المدينة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        isExpanded: true,
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 