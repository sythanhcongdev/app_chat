import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utilities/keys/message_keys.dart';

class MessageFirebaseProvider {
  final FirebaseFirestore fireStore;

  MessageFirebaseProvider({
    required this.fireStore,
  });

  Future<void> addMessage({required Map<String, dynamic> messageMap}) async {
    await fireStore.collection(MessageKeys.collection).add(messageMap);
  }

  Stream<List<Map<String, dynamic>?>> getMessages({
    required String conversationId,
  }) {
    final querySnapshotStream = fireStore
        .collection(MessageKeys.collection)
        .where(MessageKeys.conversationId, isEqualTo: conversationId)
        .orderBy(MessageKeys.timeStamp, descending: true)
        .snapshots();

    return querySnapshotStream.map(
      (event) => event.docs.map((e) => e.data()).toList(),
    );
  }
}
