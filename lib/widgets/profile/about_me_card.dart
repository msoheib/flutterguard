import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutMeCard extends StatefulWidget {
  final bool isEditable;

  const AboutMeCard({
    super.key,
    required this.isEditable,
  });

  @override
  _AboutMeCardState createState() => _AboutMeCardState();
}

class _AboutMeCardState extends State<AboutMeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30.5, 16, 30.5, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.isEditable)
                GestureDetector(
                  onTap: () {
                    // Add edit functionality here
                  },
                  child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
                ),
              Row(
                children: [
                  const Text(
                    'معلومات عنك',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/about.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}