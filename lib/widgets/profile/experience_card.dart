import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExperienceCard extends StatefulWidget {
  final bool isEditable;

  const ExperienceCard({
    super.key,
    required this.isEditable,
  });

  @override
  _ExperienceCardState createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  final List<Map<String, String>> _experiences = [];

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
                  onTap: _addExperience,
                  child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
                ),
              Row(
                children: [
                  const Text(
                    'خبراتك في العمل',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/work_experience.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._experiences.map((experience) => _buildExperienceItem(
            title: experience['title'] ?? '',
            company: experience['company'] ?? '',
            date: experience['date'] ?? '',
          )),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String title,
    required String company,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  company,
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
            SvgPicture.asset('assets/media/icons/job.svg', width: 24, height: 24),
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
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }

  void _addExperience() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String company = '';
        String date = '';

        return AlertDialog(
          title: const Text('Add Experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(hintText: "Enter job title"),
              ),
              TextField(
                onChanged: (value) => company = value,
                decoration: const InputDecoration(hintText: "Enter company name"),
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
                  _experiences.add({
                    'title': title,
                    'company': company,
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