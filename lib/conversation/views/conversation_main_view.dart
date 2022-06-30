import '../conversation.dart';

class ConversationRepository {
  final ConversationRepository conversationFirebaseProvider;

  ConversationRepository({
    required this.conversationFirebaseProvider,
  });

  Future<Conversation?> getConversation({
    required String senderUID,
    required String receiverUID,
  }) async {
    final conversationMap = await this.
  }
}
