import 'package:flutter/material.dart';
import '../../widgets/company_route_wrapper.dart';

class CompanyChatPage extends StatelessWidget {
  const CompanyChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 1,  // Messages tab
      child: Container(
        color: const Color(0xFFFBFBFB),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: const Text(
                  'المحادثات',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D1E),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Chat List
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'لا توجد محادثات',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          color: Colors.grey,
                        ),
                      ),
                    ],
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