import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utilities/keys/conversation_keys.dart';

class ChatFirebaseProvider {
  final FirebaseFirestore fireStore;

  ChatFirebaseProvider({
    required this.fireStore,
  });

  Future<List<Map<String, dynamic>>> getChats({
    required String loginUID,
  }) async {
    final querySnap = await fireStore
        .collection(ConversationKeys.collectionName)
        .where(ConversationKeys.members, arrayContains: loginUID)
        .get();
    return querySnap.docs.map((e) => e.data()).toList();
  }
}
