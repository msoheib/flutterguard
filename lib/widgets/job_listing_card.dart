import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/job_post.dart';

class JobListingCard extends StatelessWidget {
  final JobPost? job;
  final String? title;
  final String? company;
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? salary;
  final String? jobType;
  final String? workType;
  final String? status;
  final VoidCallback onTap;
  final String? buttonText;
  final Color? buttonColor;

  const JobListingCard({
    super.key,
    this.job,
    this.title,
    this.company,
    this.location,
    this.salary,
    this.jobType,
    this.workType,
    this.status,
    required this.onTap,
    this.buttonText,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = job?.title ?? title ?? '';
    final displayCompany = job?.company ?? company ?? '';
    final displayLocation = job?.location ?? location ?? {};
    final displaySalary = job?.salary ?? salary ?? {};
    final displayJobType = job?.type ?? jobType ?? '';
    final displayWorkType = job?.workType ?? workType ?? '';
    final displayButtonText = buttonText ?? 'عرض التفاصيل';
    final displayButtonColor = buttonColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 319,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2D99AAC5),
              blurRadius: 62,
              offset: Offset(0, 4),
            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/media/icons/bookmark.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              const Text(
                                'شهريا',
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 10,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${displaySalary['amount']} ${displaySalary['currency']} /',
                                style: const TextStyle(
                                  color: Color(0xFF1A1D1E),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                displayTitle,
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
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFF3F3F3),
                                  shape: OvalBorder(),
                                ),
                                child: const Icon(Icons.business, color: Color(0xFF6A6A6A)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                displayLocation['city'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 2,
                                height: 2,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF6A6A6A),
                                  shape: OvalBorder(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayCompany,
                                style: const TextStyle(
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
                          color: const Color(0xFFF6F7F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          displayJobType,
                          style: const TextStyle(
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
                          color: const Color(0xFFF6F7F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          displayWorkType,
                          style: const TextStyle(
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: displayButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayButtonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 