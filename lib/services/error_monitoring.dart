class ErrorMonitoring {
  static void logError(String error, StackTrace stackTrace) {
    // Implement your error logging service (e.g., Firebase Crashlytics)
    print('Error: $error');
    print('StackTrace: $stackTrace');
  }

  static void logDataValidationError(String collection, String documentId, String error) {
    // Log data validation errors specifically
    print('Data Validation Error:');
    print('Collection: $collection');
    print('Document ID: $documentId');
    print('Error: $error');
  }
} 