import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import 'admin_support_page.dart';

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          color: Color(0xFF1A1D1E),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          _buildBatteryIcon(),
                          const SizedBox(width: 5),
                          _buildWifiIcon(),
                          const SizedBox(width: 5),
                          _buildCellularIcon(),
                        ],
                      ),
                    ],
                  ),
                ),

                // App Bar Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSquareButton(Icons.notifications),
                      const Text(
                        'أسم التطبيق',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 20,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      _buildSquareButton(Icons.menu),
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
                      _buildSquareButton(Icons.filter_list),
                    ],
                  ),
                ),

                // Welcome Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '2024',
                              style: TextStyle(
                                color: Color(0xFF1A1D1E),
                                fontSize: 15,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'مرحبا أدمن',
                            style: TextStyle(
                              color: Color(0xFF1A1D1E),
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'إليك المعلومات حول جميع الصفحات',
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 12,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatCard(
                                  'الوظائف',
                                  _stats['totalJobs']?.toString() ?? '0',
                                  Icons.work,
                                ),
                                _buildStatCard(
                                  'الشركات',
                                  _stats['totalCompanies']?.toString() ?? '0',
                                  Icons.business,
                                ),
                                _buildStatCard(
                                  'المستخدمين',
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
                          fontSize: 14,
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

                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'طلبات تسجيل الشركات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1D1E),
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
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final companies = snapshot.data ?? [];
                          
                          if (companies.isEmpty) {
                            return const Center(
                              child: Text('لا يوجد طلبات تسجيل جديدة'),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: companies.length,
                            itemBuilder: (context, index) {
                              final company = companies[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  title: Text(company['name'] ?? 'شركة'),
                                  subtitle: Text(company['email'] ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
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
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
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
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) { // Support tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminSupportPage()),
            );
          }
          // Handle other navigation items
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            label: 'الرئيسة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 20),
            label: 'المستخدمين',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, size: 20),
            label: 'الشركات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent, size: 20),
            label: 'الدعم الفني',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 20),
            label: 'الأعدادت',
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF4CA6A8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 24.33,
      height: 11.33,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1A1D1E), width: 1),
        borderRadius: BorderRadius.circular(2.67),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D1E),
            borderRadius: BorderRadius.circular(1.33),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiIcon() {
    return const Icon(
      Icons.wifi,
      size: 15.33,
      color: Color(0xFF1A1D1E),
    );
  }

  Widget _buildCellularIcon() {
    return const Icon(
      Icons.signal_cellular_4_bar,
      size: 17,
      color: Color(0xFF1A1D1E),
    );
  }
} 