import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EducationCard extends StatefulWidget {
  final bool isEditable;

  const EducationCard({
    super.key,
    required this.isEditable,
  });

  @override
  _EducationCardState createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  final List<Map<String, String>> _educations = [];

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
                  onTap: _addEducation,
                  child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
                ),
              Row(
                children: [
                  const Text(
                    'التعليم',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/education.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ..._educations.map((education) => _buildEducationItem(
            degree: education['degree'] ?? '',
            institution: education['institution'] ?? '',
            date: education['date'] ?? '',
          )),
        ],
      ),
    );
  }

  Widget _buildEducationItem({
    required String degree,
    required String institution,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  degree,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  institution,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontFamily: 'Open Sans',
                  ),
                ),
              ],
            ),
            SvgPicture.asset('assets/media/icons/degree.svg', width: 24, height: 24),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addEducation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String degree = '';
        String institution = '';
        String date = '';

        return AlertDialog(
          title: const Text('Add Education'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => degree = value,
                decoration: const InputDecoration(hintText: "Enter degree"),
              ),
              TextField(
                onChanged: (value) => institution = value,
                decoration: const InputDecoration(hintText: "Enter institution"),
              ),
              TextField(
                onChanged: (value) => date = value,
                decoration: const InputDecoration(hintText: "Enter date range"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                setState(() {
                  _educations.add({
                    'degree': degree,
                    'institution': institution,
                    'date': date,
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}