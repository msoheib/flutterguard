import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationCounterBanner extends StatelessWidget {
  const ApplicationCounterBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        int applicationCount = 0;
        
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          applicationCount = userData?['applicationCount'] ?? 0;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 169,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x07000000),
                  blurRadius: 12,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA6A8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA6A8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  right: 22,
                  top: 52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        applicationCount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'الوظائف المقدمة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 