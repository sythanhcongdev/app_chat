import '../../connect/import_models.dart';
import '../../connect/import_provider.dart';

class MessageRepository {
  final MessageFirebaseProvider messageFirebaseProvider;

  MessageRepository({
    required this.messageFirebaseProvider,
  });

  Future<void> sendMessage({required Message message}) async {
    await messageFirebaseProvider.addMessage(messageMap: message.toMap());
  }

  Stream<List<Message?>> getMessages({required String conversationId}) {
    final messageMapStream =
        messageFirebaseProvider.getMessages(conversationId: conversationId);

    return messageMapStream.map(
      (event) => event.map(
        (e) {
          return e != null ? Message.fromMap(e) : null;
        },
      ).toList(),
    );
  }
}
