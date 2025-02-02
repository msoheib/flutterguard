void main() {
  group('ChatService Tests', () {
    test('createChat validates input parameters', () async {
      final chatService = ChatService(MockFirebaseFirestore());
      
      expect(
        () => chatService.createChat(
          jobSeekerId: '',
          companyId: 'company1',
          jobId: 'job1'
        ),
        throwsException
      );
    });
    
    // Add more tests...
  });
} 