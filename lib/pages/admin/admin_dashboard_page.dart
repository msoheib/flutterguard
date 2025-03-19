import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_support_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/navigation/nav_bars/admin_nav_bar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AdminService _adminService = AdminService();
  Map<String, int> _stats = {
    'totalJobs': 0,
    'totalCompanies': 0,
    'totalUsers': 0,
  };
  bool _isLoading = true;
  String selectedCategory = '';
  String selectedDate = '';
  DateTimeRange? dateRange;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _adminService.getDashboardStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stats: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 125,
            decoration: const ShapeDecoration(
              color: Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
          ),
          
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Status Bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildStatusBarIcons(),
                    ],
                  ),
                ),

                // App Bar Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSquareButton(
                        Icons.menu,
                        onPressed: () {
                          // Add menu functionality here if needed
                        },
                      ),
                      const Text(
                        'أسم التطبيق',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 20,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _buildSquareButton(
                        Icons.notifications,
                        onPressed: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ابحث هنا...',
                              hintStyle: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      _buildSquareButton(
                        Icons.filter_list,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.75,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFBFBFB),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  // Header
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
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
                                  
                                  // Filter Options
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          _buildFilterOption(
                                            'حالة الطلب',
                                            ['قيد الانتظار', 'مقبول', 'مرفوض'],
                                            selectedCategory,
                                            (value) => setState(() => selectedCategory = value),
                                          ),
                                          const SizedBox(height: 16),
                                          _buildDateFilter(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Apply Button
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: InkWell(
                                      onTap: () {
                                        // Apply filters and update data
                                        _applyFilters();
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Statistics Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                _buildStatContainer(
                                  'أجمالي الوظائف المنشورة',
                                  _stats['totalJobs']?.toString() ?? '0',
                                  Icons.work,
                                ),
                                const SizedBox(height: 16),
                                _buildStatContainer(
                                  'عدد الشركات',
                                  _stats['totalCompanies']?.toString() ?? '0',
                                  Icons.business,
                                ),
                                const SizedBox(height: 16),
                                _buildStatContainer(
                                  'عدد المستخدمين',
                                  _stats['totalUsers']?.toString() ?? '0',
                                  Icons.people,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Join Requests Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'طلبات الانضمام',
                        style: TextStyle(
                          color: Color(0xFF1A1D1E),
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _adminService.getPendingCompanies(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          final companies = snapshot.data ?? [];

                          if (companies.isEmpty) {
                            return const Center(
                              child: Text(
                                'لا يوجد طلبات انضمام جديدة',
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: companies.length,
                            itemBuilder: (context, index) {
                              final company = companies[index];
                              final createdAt = company['createdAt'] as Timestamp?;
                              final timeDiff = createdAt != null
                                  ? DateTime.now().difference(createdAt.toDate())
                                  : null;
                              final timeAgo = timeDiff != null
                                  ? '${timeDiff.inHours}ساعة'
                                  : '';

                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x2D99AAC5),
                                      blurRadius: 62,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6F7F8),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                'منذ $timeAgo',
                                                style: const TextStyle(
                                                  color: Color(0xFF6A6A6A),
                                                  fontSize: 10,
                                                  fontFamily: 'Cairo',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Icon(
                                                Icons.access_time,
                                                size: 10,
                                                color: Color(0xFF6A6A6A),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  company['name'] ?? 'شركة',
                                                  style: const TextStyle(
                                                    color: Color(0xFF1A1D1E),
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  width: 33,
                                                  height: 33,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFF3F3F3),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await _adminService.approveCompany(company['id']);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('تم قبول الشركة')),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('خطأ: $e')),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F3F3),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'قبول',
                                              style: TextStyle(
                                                color: Color(0xFF4CA6A8),
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await _adminService.rejectCompany(company['id']);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('تم رفض الشركة')),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('خطأ: $e')),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4CA6A8),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'رفض',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminNavBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 4:
              // Already on dashboard
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/admin/applications');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/admin/chat');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/admin/users');
              break;
            case 0:
              Navigator.pushReplacementNamed(context, '/admin/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSquareButton(IconData icon, {VoidCallback? onPressed}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4CA6A8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatContainer(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      height: 95,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      decoration: ShapeDecoration(
        color: const Color(0xFF4CA6A8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBarIcons() {
    return Row(
      children: [
        SvgPicture.asset('assets/battery_icon.svg', width: 25, height: 12),
        const SizedBox(width: 5),
        SvgPicture.asset('assets/wifi_icon.svg', width: 15, height: 11),
        const SizedBox(width: 5),
        SvgPicture.asset('assets/Menu.svg', width: 17, height: 10),
      ],
    );
  }

  Widget _buildFilterOption(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: options.map((option) => 
              RadioListTile<String>(
                title: Text(
                  option,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
                value: option,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(value!),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'التاريخ',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => dateRange = picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF4CA6A8)),
                Text(
                  dateRange != null 
                    ? '${dateRange!.start.toString().split(' ')[0]} - ${dateRange!.end.toString().split(' ')[0]}'
                    : 'اختر التاريخ',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _applyFilters() {
    // Implement filter logic here
    // Update the companies list based on selected filters
    setState(() {
      // Filter companies based on selectedCategory and dateRange
      // Update UI accordingly
    });
  }
} 