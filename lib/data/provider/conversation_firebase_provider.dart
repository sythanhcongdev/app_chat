import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../connect/import_keys.dart';

class ConversationFirebaseProvider {
  final FirebaseFirestore fireStore;
  ConversationFirebaseProvider({
    required this.fireStore,
  });

  Future<Map<String, dynamic>?> getConversationId({
    required String senderUID,
    required String receiverUID,
  }) async {
    final members = [senderUID, receiverUID];

    final conversationQuerySnap =
        await fireStore.collection(ConversationKeys.collectionName).where(
      ConversationKeys.members,
      whereIn: [
        members,
        members.reversed.toList(),
      ],
    ).get();
    log(conversationQuerySnap.docs.length.toString());
    if (conversationQuerySnap.docs.isNotEmpty) {
      return conversationQuerySnap.docs.first.data();
    }
    return null;
  }

  Future<String> createConversation({
    required Map<String, dynamic> conversation,
  }) async {
    final conversationRef = await fireStore
        .collection(ConversationKeys.collectionName)
        .add(conversation);

    await conversationRef.update({ConversationKeys.id: conversationRef.id});
    return conversationRef.id;
  }
}
