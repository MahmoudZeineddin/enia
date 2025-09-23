import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إنشاء محادثة جديدة
  Future<DocumentReference> createConversation({
    required String name,
    required List<String> participants,
    bool isGroup = false,
    bool isDoctor = false,
    String? avatarUrl,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    return await _firestore.collection('conversations').add({
      'name': name,
      'participants': participants,
      'isGroup': isGroup,
      'isDoctor': isDoctor,
      'avatarUrl': avatarUrl,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': currentUser.uid,
      'unreadCount': 0,
      'readStatus': participants.fold<Map<String, bool>>(
        {},
        (map, userId) => {...map, userId: true},
      ),
    });
  }

  // إرسال رسالة
  Future<DocumentReference> sendMessage({
    required String conversationId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    final batch = _firestore.batch();

    // إنشاء الرسالة
    final messageRef = _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();

    batch.set(messageRef, {
      'content': content,
      'senderId': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    });

    // تحديث معلومات المحادثة
    final conversationRef = _firestore
        .collection('conversations')
        .doc(conversationId);
    batch.update(conversationRef, {
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'readStatus': {currentUser.uid: true},
      'unreadCount': FieldValue.increment(1),
    });

    await batch.commit();
    return messageRef;
  }

  // الحصول على قائمة المحادثات
  Stream<QuerySnapshot> getConversations() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // الحصول على رسائل محادثة
  Stream<QuerySnapshot> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // تحديث حالة القراءة
  Future<void> markAsRead(String conversationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    await _firestore.collection('conversations').doc(conversationId).update({
      'readStatus.${currentUser.uid}': true,
      'unreadCount': 0,
    });
  }

  // حذف رسالة
  Future<void> deleteMessage(String conversationId, String messageId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    // التحقق من أن المستخدم هو من أرسل الرسالة
    final message = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .get();

    if (message.get('senderId') != currentUser.uid) {
      throw Exception('لا يمكنك حذف رسائل الآخرين');
    }

    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  // حذف محادثة
  Future<void> deleteConversation(String conversationId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    // حذف جميع الرسائل أولاً
    final messages = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .get();

    final batch = _firestore.batch();
    for (var message in messages.docs) {
      batch.delete(message.reference);
    }

    // حذف المحادثة
    batch.delete(_firestore.collection('conversations').doc(conversationId));

    await batch.commit();
  }

  // إنشاء مجموعة جديدة
  Future<DocumentReference> createGroup({
    required String name,
    required List<String> participants,
    String? avatarUrl,
  }) async {
    return createConversation(
      name: name,
      participants: participants,
      isGroup: true,
      avatarUrl: avatarUrl,
    );
  }

  // إضافة مشاركين إلى مجموعة
  Future<void> addParticipantsToGroup(
    String conversationId,
    List<String> newParticipants,
  ) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'participants': FieldValue.arrayUnion(newParticipants),
    });
  }

  // إزالة مشاركين من مجموعة
  Future<void> removeParticipantsFromGroup(
    String conversationId,
    List<String> participantsToRemove,
  ) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'participants': FieldValue.arrayRemove(participantsToRemove),
    });
  }
}
