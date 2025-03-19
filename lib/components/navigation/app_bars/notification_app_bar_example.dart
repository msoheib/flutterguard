import 'package:flutter/material.dart';
import 'notification_app_bar.dart';

class NotificationAppBarExample extends StatelessWidget {
  const NotificationAppBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Example with bell icon (notification style)
            NotificationAppBar(
              title: 'أسم التطبيق',
              notificationCount: 3,
              onNotificationPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications button pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              // Optional: User avatar
              avatarUrl: 'https://via.placeholder.com/150',
              onAvatarPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Avatar pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildMainContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NotificationAppBar Examples',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterIconExample(),
                ),
              );
            },
            child: Text('View with Filter Icon'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPageExample(),
                ),
              );
            },
            child: Text('Go to Detail Page'),
          ),
        ],
      ),
    );
  }
}

// Example with filter icon (like company home page)
class FilterIconExample extends StatelessWidget {
  const FilterIconExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NotificationAppBar(
              title: 'أسم التطبيق',
              useFilterIcon: true, // Use filter icon instead of bell
              onNotificationPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filter button pressed'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              avatarUrl: 'https://via.placeholder.com/150',
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Home page style with filter icon'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPageExample extends StatelessWidget {
  const DetailPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text('Detail Page Content'),
      ),
    );
  }
}

// Usage examples:

// 1. For home/main screens:
// Scaffold(
//   appBar: NotificationAppBar(
//     title: 'الرئيسية',
//     notificationCount: 5,
//   ),
//   body: HomeContent(),
// )

// 2. For profile screens:
// Scaffold(
//   appBar: NotificationAppBar(
//     title: 'الملف الشخصي',
//     notificationCount: 0,
//     leadingWidget: CircleAvatar(
//       backgroundImage: userProfileImage,
//     ),
//   ),
//   body: ProfileContent(),
// )

// 3. For settings screens:
// Scaffold(
//   appBar: NotificationAppBar(
//     title: 'الإعدادات',
//     actions: [
//       IconButton(
//         icon: Icon(Icons.settings),
//         onPressed: () {},
//       ),
//     ],
//   ),
//   body: SettingsContent(),
// ) 