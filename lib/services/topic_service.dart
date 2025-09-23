import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TopicService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // إنشاء موضوع جديد
  Future<DocumentReference> createTopic({
    required String title,
    required String description,
    required String icon,
    required String createdBy,
  }) async {
    return await _firestore.collection('topics').add({
      'title': title,
      'description': description,
      'icon': icon,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'subscribers': [],
      'views': 0,
    });
  }

  // إضافة محتوى للموضوع
  Future<DocumentReference> addContent({
    required String topicId,
    required String title,
    required String type,
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    return await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('content')
        .add({
          'title': title,
          'type': type,
          'content': content,
          'metadata': metadata,
          'createdAt': FieldValue.serverTimestamp(),
          'views': 0,
          'isVisible': true,
        });
  }

  // رفع ملف وسائط
  Future<String> uploadMedia(
    String topicId,
    String fileName,
    Uint8List fileData,
  ) async {
    final ref = _storage.ref().child('topics/$topicId/$fileName');
    await ref.putData(fileData);
    return await ref.getDownloadURL();
  }

  // الاشتراك في موضوع
  Future<void> subscribeTopic(String topicId, String userId) async {
    await _firestore.collection('topics').doc(topicId).update({
      'subscribers': FieldValue.arrayUnion([userId]),
    });
  }

  // إلغاء الاشتراك من موضوع
  Future<void> unsubscribeTopic(String topicId, String userId) async {
    await _firestore.collection('topics').doc(topicId).update({
      'subscribers': FieldValue.arrayRemove([userId]),
    });
  }

  // زيادة عدد المشاهدات
  Future<void> incrementViews(String topicId) async {
    await _firestore.collection('topics').doc(topicId).update({
      'views': FieldValue.increment(1),
    });
  }

  // الحصول على قائمة المواضيع
  Stream<QuerySnapshot> getTopics() {
    return _firestore
        .collection('topics')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // الحصول على محتوى موضوع
  Stream<QuerySnapshot> getTopicContent(String topicId) {
    return _firestore
        .collection('topics')
        .doc(topicId)
        .collection('content')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // الحصول على المشتركين في موضوع
  Future<List<DocumentSnapshot>> getTopicSubscribers(String topicId) async {
    DocumentSnapshot topicDoc = await _firestore
        .collection('topics')
        .doc(topicId)
        .get();
    List<String> subscriberIds = List<String>.from(topicDoc.get('subscribers'));

    List<DocumentSnapshot> subscribers = [];
    for (String id in subscriberIds) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(id)
          .get();
      subscribers.add(userDoc);
    }

    return subscribers;
  }

  // تحديث حالة المحتوى (ظاهر/مخفي)
  Future<void> updateContentVisibility(
    String topicId,
    String contentId,
    bool isVisible,
  ) async {
    await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('content')
        .doc(contentId)
        .update({'isVisible': isVisible});
  }

  // حذف محتوى من موضوع
  Future<void> deleteContent(String topicId, String contentId) async {
    await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('content')
        .doc(contentId)
        .delete();
  }

  // حذف موضوع
  Future<void> deleteTopic(String topicId) async {
    // حذف كل المحتوى أولاً
    QuerySnapshot contentSnapshot = await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('content')
        .get();

    for (var doc in contentSnapshot.docs) {
      await doc.reference.delete();
    }

    // حذف الموضوع نفسه
    await _firestore.collection('topics').doc(topicId).delete();
  }
}
