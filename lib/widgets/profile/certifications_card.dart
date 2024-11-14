import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CertificationsCard extends StatefulWidget {
  const CertificationsCard({super.key});

  @override
  _CertificationsCardState createState() => _CertificationsCardState();
}

class _CertificationsCardState extends State<CertificationsCard> {
  final List<Map<String, String>> _certifications = [];

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
                onTap: _addCertification,
                child: SvgPicture.asset('assets/media/icons/show_more.svg', width: 24, height: 24),
              ),
              Row(
                children: [
                  const Text(
                    'الشها��ات',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/media/icons/certificates.svg', width: 24, height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          ..._certifications.map((certification) => _buildCertificationItem(
            title: certification['title'] ?? '',
            issuer: certification['issuer'] ?? '',
            date: certification['date'] ?? '',
          )),
        ],
      ),
    );
  }

  Widget _buildCertificationItem({
    required String title,
    required String issuer,
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
                  issuer,
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
            SvgPicture.asset('assets/media/icons/certificate.svg', width: 24, height: 24),
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

  void _addCertification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String issuer = '';
        String date = '';

        return AlertDialog(
          title: const Text('Add Certification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(hintText: "Enter certification title"),
              ),
              TextField(
                onChanged: (value) => issuer = value,
                decoration: const InputDecoration(hintText: "Enter issuing organization"),
              ),
              TextField(
                onChanged: (value) => date = value,
                decoration: const InputDecoration(hintText: "Enter date of certification"),
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
                  _certifications.add({
                    'title': title,
                    'issuer': issuer,
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