import 'package:flutter/material.dart';

class JobPosting extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String salary;
  final String description;

  const JobPosting({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              company,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, size: 16),
                SizedBox(width: 4),
                Text(location, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money, size: 16),
                SizedBox(width: 4),
                Text(salary, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Job Description',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement apply functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Application submitted!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }
}
