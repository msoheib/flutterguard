import 'package:flutter/material.dart';

class ChatListItem {
  final String name;
  final String projectName;
  final String? avatarUrl;
  final bool hasUnreadMessages;
  
  ChatListItem({
    required this.name,
    required this.projectName,
    this.avatarUrl,
    this.hasUnreadMessages = false,
  });
}

class ChatList extends StatelessWidget {
  final List<ChatListItem> items;
  final Function(ChatListItem)? onItemTap;
  final String title;
  
  const ChatList({
    Key? key,
    required this.items,
    this.onItemTap,
    this.title = 'المحادثات',
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          // Chat list
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: Colors.grey.withOpacity(0.2),
                indent: 68,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: onItemTap != null ? () => onItemTap!(item) : null,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side - Avatar and text
                        Expanded(
                          child: Row(
                            children: [
                              // Avatar with building icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.business,
                                    color: Color(0xFF4CA6A8),
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              // Name and project
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name.isNotEmpty ? item.name : '-',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      item.projectName.isNotEmpty ? item.projectName : '-',
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Right side - Teal indicator for unread messages
                        if (item.hasUnreadMessages)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Color(0xFF4CA6A8),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage:
// final chatItems = [
//   ChatListItem(
//     name: 'ACME',
//     projectName: 'HR',
//     hasUnreadMessages: true,
//   ),
//   ChatListItem(
//     name: 'أسم المتقدم',
//     projectName: 'project',
//     hasUnreadMessages: true,
//   ),
// ];
// 
// ChatList(items: chatItems) 