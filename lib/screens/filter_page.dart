import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> selectedSkills = [];
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
    print('Creating filters with:');
    print('  Category: $selectedCategory');
    print('  Region: $selectedRegion');
    print('  Salary Range: $salaryRange');
    print('  Date Range: $selectedDateRange');
    print('  Skills: $selectedSkills');

    final filters = {
      'category': selectedCategory,
      'dateRange': selectedDateRange != null ? {
        'start': selectedDateRange!.start,
        'end': selectedDateRange!.end,
      } : null,
      'salaryRange': {
        'min': salaryRange.start,
        'max': salaryRange.end,
      },
      'region': selectedRegion,
      'skills': selectedSkills,
    };
    print('Final filters object: $filters');
    Navigator.pop(context, filters);
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
                          InkWell(
                            onTap: _showRegionPicker,
                            child: Container(
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
                                    selectedRegion.isEmpty ? 'اختر المنطقة' : selectedRegion,
                                    style: TextStyle(
                                      color: selectedRegion.isEmpty ? const Color(0xFF6A6A6A) : Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  SvgPicture.asset(
                                    'assets/media/icons/location.svg',
                                    width: 20,
                                    height: 20,
                                  ),
                                ],
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
    final bool isSelected = selectedSkills.contains(skill);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSkills.remove(skill);
          } else {
            selectedSkills.add(skill);
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