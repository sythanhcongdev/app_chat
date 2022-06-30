import 'package:cloud_firestore/cloud_firestore.dart';

class ContactFirebaseProvider {
  final FirebaseFirestore fireStore;

  ContactFirebaseProvider({
    required this.fireStore,
  });

  Future<List<Map<String, dynamic>>> getContacts({
    required String loginUID,
  }) async {
    final userQuerySnap = await fireStore
        .collection('users')
        .where('uid', isNotEqualTo: loginUID)
        .get();
    return userQuerySnap.docs
        .map((queryDocSnap) => queryDocSnap.data())
        .toList();
  }
}
