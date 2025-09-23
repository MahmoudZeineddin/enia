import 'package:cloud_firestore/cloud_firestore.dart';

class Topic {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String createdBy;
  final DateTime createdAt;
  final List<String> subscribers;
  final int views;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.createdBy,
    required this.createdAt,
    required this.subscribers,
    required this.views,
  });

  factory Topic.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Topic(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      subscribers: List<String>.from(data['subscribers'] ?? []),
      views: data['views'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'subscribers': subscribers,
      'views': views,
    };
  }
}

class TopicContent {
  final String id;
  final String title;
  final String type;
  final String content;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final int views;
  final bool isVisible;

  TopicContent({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    this.metadata,
    required this.createdAt,
    required this.views,
    required this.isVisible,
  });

  factory TopicContent.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TopicContent(
      id: doc.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      content: data['content'] ?? '',
      metadata: data['metadata'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      views: data['views'] ?? 0,
      isVisible: data['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'content': content,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'views': views,
      'isVisible': isVisible,
    };
  }
}
