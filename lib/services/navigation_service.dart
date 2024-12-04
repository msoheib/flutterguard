import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/chat_page.dart';
import '../pages/settings_page.dart';
import '../pages/favorites_page.dart';

class NavigationService {
  static void navigateToPage(BuildContext context, int index) {
    Widget page;
    
    switch (index) {
      case 0: // Settings
        page = const SettingsPage();
        break;
      case 1: // Favorites
        page = const FavoritesPage();
        break;
      case 2: // Chat
        page = const ChatPage();
        break;
      case 3: // Home
        page = const HomePage();
        break;
      default:
        page = const HomePage();
    }

    // Replace the current page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
} 