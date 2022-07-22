import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationFirebaseProvider {
  final FirebaseFirestore fireStore;

  RegistrationFirebaseProvider({required this.fireStore});

  Future<Map<String, dynamic>?> getUserDetails({required String uid}) async {
    final userQuerySnap = await fireStore.collection('users').doc(uid).get();
    return userQuerySnap.data();
  }

  Future<void> registerUser({required Map<String, dynamic> user}) async {
    await fireStore.collection('users').doc(user['uid'].toString()).set(user);
  }
}
