Future<void> migrateChatData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Get all chats
  final QuerySnapshot chats = await firestore.collection('chats').get();
  
  // Batch updates
  final batch = firestore.batch();
  
  for (var chat in chats.docs) {
    final data = chat.data() as Map<String, dynamic>;
    
    // Fix field names
    if (data.containsKey('applicantId')) {
      data['jobSeekerId'] = data['applicantId'];
      data.remove('applicantId');
    }
    
    // Add missing fields with defaults
    if (!data.containsKey('unreadCompany')) {
      data['unreadCompany'] = false;
    }
    if (!data.containsKey('unreadJobSeeker')) {
      data['unreadJobSeeker'] = false;
    }
    
    // Update document
    batch.update(chat.reference, data);
  }
  
  await batch.commit();
} 