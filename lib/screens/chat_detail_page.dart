import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../widgets/custom_app_bar.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;
  final bool isCompany;

  const ChatDetailPage({
    super.key,
    required this.chat,
    required this.isCompany,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Mark messages as read when opening chat
    _chatService.markAsRead(widget.chat.id, 
      widget.isCompany ? widget.chat.companyId : widget.chat.jobSeekerId, 
      widget.isCompany);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      await _chatService.sendMessage(
        widget.chat.id,
        widget.isCompany ? widget.chat.companyId : widget.chat.jobSeekerId,
        _messageController.text.trim(),
      );
      _messageController.clear();
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: widget.isCompany ? 'الباحث عن عمل' : 'الشركة',
              onBackPressed: () => Navigator.pop(context),
            ),

            // Messages List
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _chatService.getMessages(widget.chat.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد رسائل',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    );
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = widget.isCompany 
                        ? message.senderId == widget.chat.companyId
                        : message.senderId == widget.chat.jobSeekerId;

                      return _MessageBubble(
                        message: message,
                        isMe: isMe,
                      );
                    },
                  );
                },
              ),
            ),

            // Message Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1E000000),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _messageController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: 'اكتب رسالتك هنا...',
                          hintStyle: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 14,
                            fontFamily: 'Cairo',
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6A8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 24,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF4CA6A8) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF1A1D1E),
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
} 