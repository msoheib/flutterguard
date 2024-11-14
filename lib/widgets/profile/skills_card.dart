import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SkillsCard extends StatefulWidget {
  const SkillsCard({super.key});

  @override
  _SkillsCardState createState() => _SkillsCardState();
}

class _SkillsCardState extends State<SkillsCard> {
  final List<String> _skills = [];

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
              GestureDetector(
                onTap: _addSkill,
                child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
              ),
              Row(
                children: [
                  const Text(
                    'المهارات',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/skills.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: _skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(
        skill,
        style: const TextStyle(
          color: Color(0xFF6A6A6A),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Cairo',
        ),
      ),
      backgroundColor: const Color(0xFFF6F7F8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _addSkill() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newSkill = '';

        return AlertDialog(
          title: const Text('Add Skill'),
          content: TextField(
            onChanged: (value) => newSkill = value,
            decoration: const InputDecoration(hintText: "Enter new skill"),
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
                  _skills.add(newSkill);
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