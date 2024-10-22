import 'package:flutter/material.dart';

class HiringCompanyProfile extends StatelessWidget {
  const HiringCompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/company_logo_placeholder.png'),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'SecureCorp',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Leading Security Solutions Provider',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('www.securecorp.com'),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('jobs@securecorp.com'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('+1 (800) 555-0123'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Los Angeles, CA'),
          ),
          SizedBox(height: 16),
          Text(
            'About Us',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'SecureCorp is a leading provider of security solutions, offering a wide range of services including on-site security, remote monitoring, and risk assessment. With over 20 years of experience, we pride ourselves on our professional and reliable security personnel.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          Text(
            'Open Positions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          OpenPositionItem(
            title: 'Night Shift Security Guard',
            location: 'Los Angeles, CA',
            salary: '\$15 - \$20 per hour',
          ),
          OpenPositionItem(
            title: 'Security Supervisor',
            location: 'San Francisco, CA',
            salary: '\$22 - \$28 per hour',
          ),
          OpenPositionItem(
            title: 'Corporate Security Officer',
            location: 'New York, NY',
            salary: '\$18 - \$25 per hour',
          ),
        ],
      ),
    );
  }
}

class OpenPositionItem extends StatelessWidget {
  final String title;
  final String location;
  final String salary;

  const OpenPositionItem({
    super.key,
    required this.title,
    required this.location,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 4),
                Text(location, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16),
                SizedBox(width: 4),
                Text(salary, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
