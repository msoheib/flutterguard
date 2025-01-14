import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/app_theme.dart';
import '../pages/application_details_page.dart';

class ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback? onViewDetails;

  const ApplicationCard({
    super.key,
    required this.application,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
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
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 168,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'شهريا',
                              style: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 10,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                                height: 1.40,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${application.salary} ر.س /',
                              style: TextStyle(
                                color: Color(0xFF1A1D1E),
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              application.jobTitle,
                              style: TextStyle(
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
                              decoration: ShapeDecoration(
                                color: Color(0xFFF3F3F3),
                                shape: OvalBorder(),
                              ),
                              child: application.companyLogo != null
                                  ? ClipOval(
                                      child: Image.network(
                                        application.companyLogo!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              application.location,
                              style: TextStyle(
                                color: Color(0xFF6A6A6A),
                                fontSize: 12,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 1.90,
                              height: 2,
                              decoration: ShapeDecoration(
                                color: Color(0xFF6A6A6A),
                                shape: OvalBorder(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              application.companyName,
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
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6F7F8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        application.jobType,
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 10,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: ShapeDecoration(
                        color: Color(0xFFF6F7F8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        application.workType,
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 10,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicationDetailsPage(
                          application: application,
                        ),
                      ),
                    );
                  },
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
                        'عرض التفاصيل',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
} 