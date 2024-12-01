import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:security_guard/models/job_post.dart';
import 'package:security_guard/screens/job_detail_page.dart';

class JobListingCard extends StatelessWidget {
  final JobPost job;

  const JobListingCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
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
                              '${job.salary['amount']} ${job.salary['currency']} /',
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
                              job.title,
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
                              child: job.companyLogo.isNotEmpty
                                  ? Image.network(job.companyLogo)
                                  : const Icon(Icons.business, color: Color(0xFF6A6A6A)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              job.location,
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
                              job.company,
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
                        job.title,
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
                        job.type,
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage(job: job),
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