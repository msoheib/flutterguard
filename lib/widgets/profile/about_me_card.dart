baimport 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutMeCard extends StatefulWidget {
  const AboutMeCard({super.key});

  @override
  _AboutMeCardState createState() => _AboutMeCardState();
}

class _AboutMeCardState extends State<AboutMeCard> {
  String _aboutMeText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30.5, 24, 30.5, 0),
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
                onTap: _editAboutMe,
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
                  SvgPicture.asset('assets/media/icons/about_me.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _aboutMeText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  void _editAboutMe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit About Me'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _aboutMeText = value;
              });
            },
            controller: TextEditingController(text: _aboutMeText),
            decoration: const InputDecoration(hintText: "Enter your about me text"),
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}