import 'package:flutter/material.dart';

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(75, 21, 75, 8),
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}