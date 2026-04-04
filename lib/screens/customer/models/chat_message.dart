enum MessageType { text, image, orderUpdate, system }

enum MessageSender { customer, restaurant, delivery }

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });
}
