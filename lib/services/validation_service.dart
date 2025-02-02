class ValidationService {
  static bool isValidChat(Map<String, dynamic> data) {
    final requiredFields = [
      'jobSeekerId',
      'companyId',
      'jobId',
      'lastMessageTime',
      'unreadCompany',
      'unreadJobSeeker'
    ];
    
    return requiredFields.every((field) => data.containsKey(field) && data[field] != null);
  }

  static bool isValidMessage(Map<String, dynamic> data) {
    final requiredFields = [
      'chatId',
      'senderId',
      'content',
      'timestamp',
      'isRead'
    ];
    
    return requiredFields.every((field) => data.containsKey(field) && data[field] != null);
  }
} 