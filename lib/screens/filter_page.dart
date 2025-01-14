import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/city_service.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  
  String? _selectedLocation;
  List<String> _selectedSkills = [];

  final List<String> skills = [
    'حارس أمن',
    'تقييم الثغرات',
    'مراقبة الكاميرات',
    'إدارة الأزمات',
    'مهارات التواصل',
    'اللياقة البدنية'
  ];

  String selectedCategory = '';
  DateTimeRange? selectedDateRange;
  RangeValues salaryRange = const RangeValues(2000, 4000);
  String selectedRegion = '';

  // Category options
  final List<String> categories = ['حارس أمن', 'مشرف أمن', 'مدير أمن', 'فني كاميرات'];

  // Region options
  final List<String> regions = ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة'];

  final CityService _cityService = CityService();
  List<String> _cities = [];
  bool _isLoadingCities = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      await _cityService.initializeCities();
      _cityService.getCities().listen((cities) {
        if (mounted) {
          setState(() {
            _cities = cities;
            _isLoadingCities = false;
          });
        }
      });
    } catch (e) {
      print('Error loading cities: $e');
      if (mounted) {
        setState(() {
          _isLoadingCities = false;
        });
      }
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
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
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) => 
            ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showRegionPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: regions.map((region) => 
            ListTile(
              title: Text(region),
              onTap: () {
                setState(() {
                  selectedRegion = region;
                });
                Navigator.pop(context);
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _applyFilters() {
    final filters = {
      'salaryMin': salaryRange.start.toInt(),
      'salaryMax': salaryRange.end.toInt(),
      'location': _selectedLocation,
      'title': _jobTitleController.text,
      'skills': _selectedSkills,
    };

    print('Applying filters before cleanup: $filters'); // Debug log

    // Remove null values
    filters.removeWhere((key, value) => 
      value == null || 
      (value is String && value.isEmpty) || 
      (value is List && value.isEmpty)
    );

    print('Applying filters after cleanup: $filters'); // Debug log
    Navigator.pop(context, filters);
  }

  @override
  void dispose() {
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with drag handle
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE1E1E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الفلتر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Category Filter
                  _buildFilterSection(
                    'فئة',
                    InkWell(
                      onTap: _showCategoryPicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 18),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              selectedCategory.isEmpty ? 'اختر الفئة' : selectedCategory,
                              style: TextStyle(
                                color: selectedCategory.isEmpty ? const Color(0xFF6A6A6A) : Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Date Filter
                  _buildFilterSection(
                    'تاريخ الوظيفة',
                    InkWell(
                      onTap: _selectDateRange,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 18),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  selectedDateRange != null 
                                    ? '${selectedDateRange!.start.toString().split(' ')[0]} - ${selectedDateRange!.end.toString().split(' ')[0]}'
                                    : 'اختر التاريخ',
                                  style: TextStyle(
                                    color: selectedDateRange != null ? Colors.black : const Color(0xFF6A6A6A),
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                SvgPicture.asset(
                                  'assets/media/icons/calendar.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Salary and Region Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Salary Filter
                      Expanded(
                        child: _buildFilterSection(
                          'المرتب',
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${salaryRange.start.toInt()} - ${salaryRange.end.toInt()} ريال',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RangeSlider(
                                values: salaryRange,
                                min: 1000,
                                max: 10000,
                                divisions: 90,
                                activeColor: const Color(0xFF4CA6A8),
                                labels: RangeLabels(
                                  '${salaryRange.start.toInt()} ريال',
                                  '${salaryRange.end.toInt()} ريال',
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    salaryRange = values;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Region Filter
                      Expanded(
                        child: _buildFilterSection(
                          'المنطقة',
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoadingCities
                                ? const Center(child: CircularProgressIndicator())
                                : DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedRegion.isEmpty ? null : selectedRegion,
                                      hint: const Text(
                                        'اختر المدينة',
                                        style: TextStyle(
                                          color: Color(0xFF6A6A6A),
                                          fontSize: 14,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      isExpanded: true,
                                      items: _cities.map((String city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: const TextStyle(
                                              color: Color(0xFF6A6A6A),
                                              fontSize: 14,
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedRegion = newValue ?? '';
                                          _selectedLocation = newValue;
                                        });
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Skills Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'المهارات المطلوبة',
                        style: TextStyle(
                          color: Color(0xFF1A1D1E),
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: skills.map((skill) => _buildSkillChip(skill)).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Apply Button at bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: InkWell(
              onTap: _applyFilters,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: const Color(0xFF4CA6A8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'تطبيق',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    final bool isSelected = _selectedSkills.contains(skill);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSkills.remove(skill);
          } else {
            _selectedSkills.add(skill);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF4CA6A8) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          skill,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6A6A6A),
            fontSize: 10,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 