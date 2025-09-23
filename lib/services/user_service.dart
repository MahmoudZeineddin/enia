import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // تحديث الملف الشخصي
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? address,
    Map<String, dynamic>? medicalInfo,
    Map<String, dynamic>? professionalInfo,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    final userData = <String, dynamic>{};
    if (name != null) userData['name'] = name;
    if (phone != null) userData['phone'] = phone;
    if (address != null) userData['address'] = address;
    if (medicalInfo != null) userData['medicalInfo'] = medicalInfo;
    if (professionalInfo != null)
      userData['professionalInfo'] = professionalInfo;

    await _firestore.collection('users').doc(currentUser.uid).update(userData);
  }

  // تحميل صورة الملف الشخصي
  Future<String> uploadProfilePicture(Uint8List imageData) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    final ref = _storage.ref().child('profile_pictures/${currentUser.uid}');
    await ref.putData(imageData);
    return await ref.getDownloadURL();
  }

  // تحديث صورة الملف الشخصي
  Future<void> updateProfilePicture(String imageUrl) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    await _firestore.collection('users').doc(currentUser.uid).update({
      'avatarUrl': imageUrl,
    });
  }

  // الحصول على معلومات المستخدم
  Future<DocumentSnapshot> getUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  // الحصول على إحصائيات المستخدم
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final stats = <String, dynamic>{};

    // عدد المواضيع المشترك بها
    final topicsQuery = await _firestore
        .collection('topics')
        .where('subscribers', arrayContains: userId)
        .get();
    stats['subscribedTopics'] = topicsQuery.size;

    // عدد المحادثات النشطة
    final chatsQuery = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .get();
    stats['activeChats'] = chatsQuery.size;

    // للأطباء: عدد المرضى
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.get('userType') == 'doctor') {
      final patientsQuery = await _firestore
          .collection('users')
          .where('doctorId', isEqualTo: userId)
          .get();
      stats['patientsCount'] = patientsQuery.size;
    }

    // للمرضى: عدد الأسئلة المطروحة
    if (userDoc.get('userType') == 'patient') {
      final questionsQuery = await _firestore
          .collection('questions')
          .where('userId', isEqualTo: userId)
          .get();
      stats['questionsCount'] = questionsQuery.size;
    }

    return stats;
  }

  // تحديث الإعدادات
  Future<void> updateSettings({
    required bool notificationsEnabled,
    required Map<String, bool> privacySettings,
    String? language,
    String? theme,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    await _firestore.collection('users').doc(currentUser.uid).update({
      'settings': {
        'notificationsEnabled': notificationsEnabled,
        'privacySettings': privacySettings,
        if (language != null) 'language': language,
        if (theme != null) 'theme': theme,
      },
    });
  }

  // الحصول على إعدادات المستخدم
  Future<Map<String, dynamic>> getUserSettings() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    final doc = await _firestore.collection('users').doc(currentUser.uid).get();
    return doc.get('settings') as Map<String, dynamic>;
  }

  // تغيير كلمة المرور
  Future<void> changePassword(String newPassword) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    await currentUser.updatePassword(newPassword);
  }

  // تحديث البريد الإلكتروني
  Future<void> updateEmail(String newEmail) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    await currentUser.updateEmail(newEmail);
    await _firestore.collection('users').doc(currentUser.uid).update({
      'email': newEmail,
    });
  }

  // حذف الحساب
  Future<void> deleteAccount() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('يجب تسجيل الدخول أولاً');

    // حذف بيانات المستخدم
    await _firestore.collection('users').doc(currentUser.uid).delete();

    // حذف صورة الملف الشخصي
    try {
      await _storage
          .ref()
          .child('profile_pictures/${currentUser.uid}')
          .delete();
    } catch (e) {
      // تجاهل الخطأ إذا لم تكن هناك صورة
    }

    // حذف الحساب
    await currentUser.delete();
  }
}
