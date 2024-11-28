import 'package:flutter/material.dart';

class JobseekerProfile extends StatelessWidget {
  const JobseekerProfile({super.key});

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
              backgroundImage: AssetImage('assets/media/icons/profile_placeholder.png'),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Security Guard',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.email),
            title: Text('john.doe@example.com'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('+1 (555) 123-4567'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('New York, NY'),
          ),
          SizedBox(height: 16),
          Text(
            'Experience',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          ExperienceItem(
            company: 'ABC Security',
            position: 'Senior Security Guard',
            duration: '2018 - Present',
          ),
          ExperienceItem(
            company: 'XYZ Protection Services',
            position: 'Security Guard',
            duration: '2015 - 2018',
          ),
          SizedBox(height: 16),
          Text(
            'Certifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          CertificationItem(
            name: 'Certified Protection Officer (CPO)',
            issuer: 'International Foundation for Protection Officers',
            year: '2019',
          ),
          CertificationItem(
            name: 'First Aid and CPR',
            issuer: 'American Red Cross',
            year: '2020',
          ),
        ],
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final String company;
  final String position;
  final String duration;

  const ExperienceItem({
    super.key,
    required this.company,
    required this.position,
    required this.duration,
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
            Text(company, style: Theme.of(context).textTheme.titleMedium),
            Text(position, style: Theme.of(context).textTheme.bodyMedium),
            Text(duration, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class CertificationItem extends StatelessWidget {
  final String name;
  final String issuer;
  final String year;

  const CertificationItem({
    super.key,
    required this.name,
    required this.issuer,
    required this.year,
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
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            Text(issuer, style: Theme.of(context).textTheme.bodyMedium),
            Text(year, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
