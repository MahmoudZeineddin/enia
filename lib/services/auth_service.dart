import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  // إنشاء حساب جديد
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
    String userType, // 'doctor' or 'patient'
    String name,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // إنشاء وثيقة المستخدم في Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // الحصول على المستخدم الحالي
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // التحقق من نوع المستخدم
  Future<String?> getUserType(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.get('userType') as String?;
      }
      return null;
    } catch (e) {
      throw e;
    }
  }
}
