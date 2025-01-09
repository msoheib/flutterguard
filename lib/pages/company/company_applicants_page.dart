import 'package:flutter/material.dart';
import '../../widgets/company_route_wrapper.dart';

class CompanyApplicantsPage extends StatelessWidget {
  const CompanyApplicantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
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
                child: const Center(
                  child: Text(
                    'المتقدمين',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 20,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'صفحة المتقدمين',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 