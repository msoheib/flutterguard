import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguagesCard extends StatefulWidget {
  const LanguagesCard({super.key});

  @override
  _LanguagesCardState createState() => _LanguagesCardState();
}

class _LanguagesCardState extends State<LanguagesCard> {
  final List<String> _languages = [];

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
                onTap: _addLanguage,
                child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
              ),
              Row(
                children: [
                  const Text(
                    'اللغات',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/languages.svg', width: 24, height: 24),
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
            children: _languages.map((language) => _buildLanguageChip(language)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    return Chip(
      label: Text(
        language,
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

  void _addLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newLanguage = '';

        return AlertDialog(
          title: const Text('Add Language'),
          content: TextField(
            onChanged: (value) => newLanguage = value,
            decoration: const InputDecoration(hintText: "Enter new language"),
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
                  _languages.add(newLanguage);
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