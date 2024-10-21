// lib/pages/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Center(child: Text('Profile information will be displayed here')),
    );
  }
}