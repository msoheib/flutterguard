import 'package:cloud_firestore/cloud_firestore.dart';

class Application {
  static const String STATUS_PENDING = 'pending';
  static const String STATUS_ACCEPTED = 'accepted';
  static const String STATUS_REJECTED = 'rejected';

  final String id;
  final String userId;
  final String jobId;
  final String companyId;
  final String status;
  final DateTime appliedDate;
  final DateTime? updatedAt;
  final String jobTitle;
  final String companyName;
  final String? companyLogo;
  final String location;
  final Map<String, dynamic> locationMap;
  final double salary;
  final Map<String, dynamic> salaryMap;
  final String jobType;
  final String workType;
  final String jobSeekerName;
  final String? coverLetter;
  final List<String>? attachments;

  Application({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.companyId,
    required this.status,
    required this.appliedDate,
    this.updatedAt,
    required this.jobTitle,
    required this.companyName,
    this.companyLogo,
    required this.location,
    required this.locationMap,
    required this.salary,
    required this.salaryMap,
    required this.jobType,
    required this.workType,
    required this.jobSeekerName,
    this.coverLetter,
    this.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'jobId': jobId,
      'companyId': companyId,
      'status': status,
      'appliedDate': Timestamp.fromDate(appliedDate),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'location': location,
      'locationMap': locationMap,
      'salary': salary,
      'salaryMap': salaryMap,
      'jobType': jobType,
      'workType': workType,
      'jobSeekerName': jobSeekerName,
      'coverLetter': coverLetter,
      'attachments': attachments,
    };
  }

  static Application fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Application(
      id: doc.id,
      userId: data['userId'] ?? '',
      jobId: data['jobId'] ?? '',
      companyId: data['companyId'] ?? '',
      status: data['status'] ?? STATUS_PENDING,
      appliedDate: (data['appliedDate'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
      jobTitle: data['jobTitle'] ?? '',
      companyName: data['companyName'] ?? '',
      companyLogo: data['companyLogo'],
      location: data['location'] ?? '',
      locationMap: Map<String, dynamic>.from(data['locationMap'] ?? {}),
      salary: (data['salary'] is Map ? 
          (data['salary']['amount'] ?? 0).toDouble() : 
          (data['salary'] ?? 0).toDouble()),
      salaryMap: Map<String, dynamic>.from(data['salaryMap'] ?? {}),
      jobType: data['jobType'] ?? '',
      workType: data['workType'] ?? '',
      jobSeekerName: data['jobSeekerName'] ?? '',
      coverLetter: data['coverLetter'],
      attachments: data['attachments'] != null ? List<String>.from(data['attachments']) : null,
    );
  }
} 