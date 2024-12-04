import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanyStatsPanels extends StatelessWidget {
  final int postedJobs;
  final int totalApplicants;

  const CompanyStatsPanels({
    super.key,
    required this.postedJobs,
    required this.totalApplicants,
  });

  Widget _buildPanel({
    required String title,
    required String count,
    required String iconPath,
  }) {
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 65,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 36,
                    height: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 133),
                Container(
                  width: 104,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        count,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                          height: 0.07,
                        ),
                      ),
                    ],
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
    return Container(
      width: 319,
      height: 206,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPanel(
            title: 'الوظائف المنشورة',
            count: postedJobs.toString(),
            iconPath: 'assets/media/icons/jobs.svg',
          ),
          const SizedBox(height: 16),
          _buildPanel(
            title: 'عدد المتقدمين',
            count: totalApplicants.toString(),
            iconPath: 'assets/media/icons/applicants.svg',
          ),
        ],
      ),
    );
  }
} 