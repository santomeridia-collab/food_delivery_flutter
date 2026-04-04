import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void initChat(String orderId) {
    _messages = [
      ChatMessage(
        id: '1',
        text: 'Hello! How can I help you with your order?',
        type: MessageType.text,
        sender: MessageSender.restaurant,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
    notifyListeners();
  }

  void sendMessage(String text, MessageSender sender) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      type: MessageType.text,
      sender: sender,
      timestamp: DateTime.now(),
    );
    _messages.add(message);
    notifyListeners();

    // Simulate reply
    Future.delayed(const Duration(seconds: 2), () {
      final reply = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Thank you for your message. We\'ll look into it.',
        type: MessageType.text,
        sender: MessageSender.restaurant,
        timestamp: DateTime.now(),
      );
      _messages.add(reply);
      notifyListeners();
    });
  }
}
