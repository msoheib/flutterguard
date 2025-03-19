import 'package:cloud_firestore/cloud_firestore.dart';

class WorkExperience {
  final String jobTitle;
  final String company;
  final String startDate;
  final String? endDate;
  final String description;
  final String? id;

  WorkExperience({
    required this.jobTitle,
    required this.company,
    required this.startDate,
    this.endDate,
    required this.description,
    this.id,
  });

  factory WorkExperience.fromMap(Map<String, dynamic> map) {
    return WorkExperience(
      jobTitle: map['jobTitle'] as String? ?? '',
      company: map['company'] as String? ?? '',
      startDate: map['startDate'] as String? ?? '',
      endDate: map['endDate'] as String?,
      description: map['description'] as String? ?? '',
      id: map['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }

  WorkExperience copyWith({
    String? jobTitle,
    String? company,
    String? startDate,
    String? endDate,
    String? description,
    String? id,
  }) {
    return WorkExperience(
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }
}

class Education {
  final String degree;
  final String institution;
  final String fieldOfStudy;
  final String graduationYear;
  final String notes;
  final String? id;

  Education({
    required this.degree,
    required this.institution,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.notes = '',
    this.id,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      degree: map['degree'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      fieldOfStudy: map['fieldOfStudy'] as String? ?? '',
      graduationYear: map['graduationYear'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      id: map['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'degree': degree,
      'institution': institution,
      'fieldOfStudy': fieldOfStudy,
      'graduationYear': graduationYear,
      'notes': notes,
      'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }

  Education copyWith({
    String? degree,
    String? institution,
    String? fieldOfStudy,
    String? graduationYear,
    String? notes,
    String? id,
  }) {
    return Education(
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      graduationYear: graduationYear ?? this.graduationYear,
      notes: notes ?? this.notes,
      id: id ?? this.id,
    );
  }
}

class Skill {
  final String name;
  final String proficiency;

  Skill({
    required this.name,
    this.proficiency = '',
  });

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] as String,
      proficiency: map['proficiency'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'proficiency': proficiency,
    };
  }
}

class Language {
  final String name;
  final String proficiency;

  Language({
    required this.name,
    required this.proficiency,
  });

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name'] as String,
      proficiency: map['proficiency'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'proficiency': proficiency,
    };
  }
}

class Certificate {
  final String name;
  final String issuer;
  final String issueDate;
  final String expirationDate;
  final String certificateId;

  Certificate({
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expirationDate = '',
    this.certificateId = '',
  });

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      name: map['name'] as String,
      issuer: map['issuer'] as String,
      issueDate: map['issueDate'] as String,
      expirationDate: map['expirationDate'] as String? ?? '',
      certificateId: map['certificateId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate,
      'expirationDate': expirationDate,
      'certificateId': certificateId,
    };
  }
}

class Profile {
  final String id;
  final PersonalInfo? personalInfo;
  final List<WorkExperience>? workExperiences;
  final List<Education>? education;
  final List<String>? skills;
  final List<Language>? languages;
  final List<Certificate>? certificates;
  final String? photoUrl;
  final String? resumeUrl;

  Profile({
    required this.id,
    this.personalInfo,
    this.workExperiences = const [],
    this.education = const [],
    this.skills = const [],
    this.languages = const [],
    this.certificates = const [],
    this.photoUrl,
    this.resumeUrl,
  });
  
  // Helper getters to safely access lists
  List<WorkExperience> get getWorkExperiences => workExperiences ?? [];
  List<Education> get getEducation => education ?? [];
  List<String> get getSkills => skills ?? [];
  List<Language> get getLanguages => languages ?? [];
  List<Certificate> get getCertificates => certificates ?? [];

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Parse personal info
    final personalInfoData = data['personalInfo'] as Map<String, dynamic>?;
    final personalInfo = personalInfoData != null ? PersonalInfo(
      name: personalInfoData['name'] as String? ?? '',
      profession: personalInfoData['profession'] as String? ?? '',
      about: personalInfoData['about'] as String? ?? '',
      location: personalInfoData['location'] as String? ?? '',
      phone: personalInfoData['phone'] as String? ?? '',
    ) : null;
    
    // Parse work experiences
    final workExperiencesData = data['workExperiences'] as List<dynamic>? ?? [];
    final workExperiences = workExperiencesData
        .map((exp) => WorkExperience.fromMap(exp as Map<String, dynamic>))
        .toList();
    
    // Parse education
    final educationData = data['education'] as List<dynamic>? ?? [];
    final education = educationData
        .map((edu) => Education.fromMap(edu as Map<String, dynamic>))
        .toList();
    
    // Parse skills
    final skillsData = data['skills'] as List<dynamic>? ?? [];
    final skills = skillsData.map((skill) => skill.toString()).toList();
    
    // Parse languages
    final languagesData = data['languages'] as List<dynamic>? ?? [];
    final languages = languagesData
        .map((lang) => Language.fromMap(lang as Map<String, dynamic>))
        .toList();
    
    // Parse certificates
    final certificatesData = data['certificates'] as List<dynamic>? ?? [];
    final certificates = certificatesData
        .map((cert) => Certificate.fromMap(cert as Map<String, dynamic>))
        .toList();
    
    return Profile(
      id: doc.id,
      personalInfo: personalInfo,
      workExperiences: workExperiences,
      education: education,
      skills: skills,
      languages: languages,
      certificates: certificates,
      photoUrl: data['photoUrl'] as String?,
      resumeUrl: data['resumeUrl'] as String?,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'personalInfo': personalInfo != null ? {
        'name': personalInfo?.name,
        'profession': personalInfo?.profession,
        'about': personalInfo?.about,
        'location': personalInfo?.location,
        'phone': personalInfo?.phone,
      } : null,
      'workExperiences': workExperiences?.map((exp) => exp.toMap()).toList() ?? [],
      'education': education?.map((edu) => edu.toMap()).toList() ?? [],
      'skills': skills ?? [],
      'languages': languages?.map((lang) => lang.toMap()).toList() ?? [],
      'certificates': certificates?.map((cert) => cert.toMap()).toList() ?? [],
      'photoUrl': photoUrl,
      'resumeUrl': resumeUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
  
  Profile copyWith({
    String? id,
    PersonalInfo? personalInfo,
    List<WorkExperience>? workExperiences,
    List<Education>? education,
    List<String>? skills,
    List<Language>? languages,
    List<Certificate>? certificates,
    String? photoUrl,
    String? resumeUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      personalInfo: personalInfo ?? this.personalInfo,
      workExperiences: workExperiences ?? this.workExperiences,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      certificates: certificates ?? this.certificates,
      photoUrl: photoUrl ?? this.photoUrl,
      resumeUrl: resumeUrl ?? this.resumeUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': personalInfo != null ? {
        'name': personalInfo?.name,
        'profession': personalInfo?.profession,
        'about': personalInfo?.about,
        'location': personalInfo?.location,
        'phone': personalInfo?.phone,
      } : null,
      'workExperiences': workExperiences?.map((exp) => exp.toMap()).toList() ?? [],
      'education': education?.map((edu) => edu.toMap()).toList() ?? [],
      'skills': skills ?? [],
      'languages': languages?.map((lang) => lang.toMap()).toList() ?? [],
      'certificates': certificates?.map((cert) => cert.toMap()).toList() ?? [],
      'photoUrl': photoUrl,
      'resumeUrl': resumeUrl,
    };
  }
}

class PersonalInfo {
  final String name;
  final String profession;
  final String about;
  final String location;
  final String phone;
  
  PersonalInfo({
    required this.name,
    required this.profession,
    required this.about,
    this.location = '',
    this.phone = '',
  });
  
  PersonalInfo copyWith({
    String? name,
    String? profession,
    String? about,
    String? location,
    String? phone,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      profession: profession ?? this.profession,
      about: about ?? this.about,
      location: location ?? this.location,
      phone: phone ?? this.phone,
    );
  }
} 