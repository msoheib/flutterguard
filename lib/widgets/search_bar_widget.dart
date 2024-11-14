import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'
;

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final Function(String)? onSearch;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onFilterTap,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: ShapeDecoration(
              color: const Color(0xFF4CA6A8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: IconButton(
                icon: SvgPicture.asset('assets/media/icons/adjust-horizontal-alt.svg',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              onPressed: onFilterTap,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Container(
              height: 44,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'ابحث هنا...',
                  hintStyle: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: onSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 