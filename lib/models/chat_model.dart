import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final String? imagePath;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.imagePath,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      isMe: map['isMe'] == true,
      time: map['time'] ?? '',
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isMe': isMe,
      'time': time,
      if (imagePath != null) 'imagePath': imagePath,
    };
  }
}

class ChatSession {
  final String name;
  final String specialty;
  final bool isSystem;
  final IconData? icon;
  final Color color;
  int unread;
  final List<ChatMessage> messages;

  ChatSession({
    required this.name,
    required this.specialty,
    required this.isSystem,
    this.icon,
    required this.color,
    required this.unread,
    required this.messages,
  });

  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      isSystem: map['isSystem'] == true,
      icon: map['icon'] as IconData?,
      color: map['color'] as Color? ?? Colors.blue,
      unread: map['unread'] ?? 0,
      messages: (map['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromMap(Map<String, dynamic>.from(m)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'isSystem': isSystem,
      if (icon != null) 'icon': icon,
      'color': color,
      'unread': unread,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }
}
