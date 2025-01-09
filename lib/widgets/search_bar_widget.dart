import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'
;

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onFilterTap;
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.onFilterTap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CA6A8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/media/icons/filter.svg',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'ابحث هنا...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
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