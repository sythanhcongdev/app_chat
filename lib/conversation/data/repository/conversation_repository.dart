import '../../conversation.dart';

class ConversationRepository {
  final ConversationFirebaseProvider conversationFirebaseProvider;

  ConversationRepository({
    required this.conversationFirebaseProvider,
  });

  Future<Conversation?> getConversation({
    required String senderUID,
    required String receiverUID,
  }) async {
    final conversationMap = await conversationFirebaseProvider.getConversation(
      senderUID: senderUID,
      receiverUID: receiverUID,
    );
    if (conversationMap == null) {
      return null;
    } else {
      return Conversation.fromMap(conversationMap);
    }
  }

  Future<String> createConversation({
    required Conversation conversation,
  }) async {
    final conversationId =
        await conversationFirebaseProvider.createConversation(
      conversation: conversation.toMap(),
    );
    return conversationId;
  }
}
