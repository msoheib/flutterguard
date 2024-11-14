import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(33, 13, 14, 21),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          Row(
            children: [
              SvgPicture.asset('assets/Menu.svg', width: 17, height: 10),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/wifi_icon.svg', width: 15, height: 11),
              const SizedBox(width: 5),
              SvgPicture.asset('assets/battery_icon.svg', width: 25, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}