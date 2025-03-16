class CompanyStatus {
  static const String UNDER_REVIEW = 'under_review';
  static const String APPROVED = 'approved';
  static const String REJECTED = 'rejected';
  static const String SENT_BACK = 'sent_back';

  static List<String> values = [
    UNDER_REVIEW,
    APPROVED,
    REJECTED,
    SENT_BACK,
  ];
} 