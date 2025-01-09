import 'package:flutter/material.dart';

class JobPostingList extends StatelessWidget {
  const JobPostingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        JobPostingItem(
          companyName: 'SecureCorp',
          jobTitle: 'Night Shift Security Guard',
          location: 'Los Angeles, CA',
          salary: '\$15 - \$20 per hour',
        ),
        JobPostingItem(
          companyName: 'TechInnovate',
          jobTitle: 'Software Developer',
          location: 'San Francisco, CA',
          salary: '\$80,000 - \$120,000 per year',
        ),
        JobPostingItem(
          companyName: 'GreenEnergy Co.',
          jobTitle: 'Solar Panel Installer',
          location: 'Phoenix, AZ',
          salary: '\$22 - \$30 per hour',
        ),
      ],
    );
  }
}

class JobPostingItem extends StatelessWidget {
  final String companyName;
  final String jobTitle;
  final String location;
  final String salary;

  const JobPostingItem({
    super.key,
    required this.companyName,
    required this.jobTitle,
    required this.location,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(companyName, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text(jobTitle, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement apply functionality
              },
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}
