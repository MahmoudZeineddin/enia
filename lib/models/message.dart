import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final DateTime timestamp;
  final String? mediaUrl;
  final String? mediaType;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
    this.mediaUrl,
    this.mediaType,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      content: data['content'] ?? '',
      senderId: data['senderId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      mediaUrl: data['mediaUrl'],
      mediaType: data['mediaType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    };
  }
}

class Conversation {
  final String id;
  final String name;
  final List<String> participants;
  final bool isGroup;
  final bool isDoctor;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final Map<String, bool> readStatus;
  final String createdBy;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.name,
    required this.participants,
    required this.isGroup,
    required this.isDoctor,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.readStatus,
    required this.createdBy,
    required this.createdAt,
  });

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Conversation(
      id: doc.id,
      name: data['name'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      isGroup: data['isGroup'] ?? false,
      isDoctor: data['isDoctor'] ?? false,
      avatarUrl: data['avatarUrl'],
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      unreadCount: data['unreadCount'] ?? 0,
      readStatus: Map<String, bool>.from(data['readStatus'] ?? {}),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'participants': participants,
      'isGroup': isGroup,
      'isDoctor': isDoctor,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCount': unreadCount,
      'readStatus': readStatus,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
