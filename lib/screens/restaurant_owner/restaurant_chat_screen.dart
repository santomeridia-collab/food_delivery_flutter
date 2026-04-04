import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/models/chat_message.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';

class RestaurantChatScreen extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? orderId;

  const RestaurantChatScreen({
    super.key,
    this.userId,
    this.userName,
    this.orderId,
  });

  @override
  State<RestaurantChatScreen> createState() => _RestaurantChatScreenState();
}

class _RestaurantChatScreenState extends State<RestaurantChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  String _selectedUser = 'Customer';

  final List<Map<String, String>> _recentChats = [
    {
      'name': 'John Doe',
      'orderId': 'ORD123456',
      'lastMessage': 'Where is my order?',
      'time': '5 min ago',
    },
    {
      'name': 'Jane Smith',
      'orderId': 'ORD123457',
      'lastMessage': 'Thanks for the food!',
      'time': '1 hour ago',
    },
    {
      'name': 'Mike Johnson',
      'orderId': 'ORD123458',
      'lastMessage': 'Can I change my address?',
      'time': '2 hours ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSampleMessages();
  }

  void _loadSampleMessages() {
    _messages = [
      ChatMessage(
        id: '1',
        text: 'Hello! When will my order arrive?',
        type: MessageType.text,
        sender: MessageSender.customer,
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: '2',
        text:
            'Your order is being prepared and will be delivered in 20 minutes.',
        type: MessageType.text,
        sender: MessageSender.restaurant,
        timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
      ),
    ];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: _messageController.text.trim(),
      type: MessageType.text,
      sender: MessageSender.restaurant,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Support'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 50.h,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedUser,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black87),
                items:
                    _recentChats.map((chat) {
                      return DropdownMenuItem(
                        value: chat['name'],
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              child: Icon(Icons.person, size: 16),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(chat['name']!),
                                  Text(
                                    chat['lastMessage']!,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              chat['time']!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUser = value!;
                    _loadSampleMessages();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isRestaurant = message.sender == MessageSender.restaurant;

                return Align(
                  alignment:
                      isRestaurant
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    constraints: BoxConstraints(maxWidth: 250.w),
                    decoration: BoxDecoration(
                      color:
                          isRestaurant
                              ? AppTheme.primaryColor
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                        bottomLeft:
                            isRestaurant
                                ? Radius.circular(12.r)
                                : Radius.circular(4.r),
                        bottomRight:
                            isRestaurant
                                ? Radius.circular(4.r)
                                : Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isRestaurant ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing Indicator
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
