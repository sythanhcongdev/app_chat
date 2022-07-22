import '../../connect/import_models.dart';
import '../../connect/import_package.dart';
import '../../connect/import_repository.dart';

part 'message_sender_event.dart';
part 'message_sender_state.dart';

class MessageSenderBloc extends Bloc<MessageSenderEvent, MessageSenderState> {
  final MessageRepository messageRepository;

  MessageSenderBloc(
    this.messageRepository,
  ) : super(MessageInitial()) {
    on<MessageSent>(_onMessageSentToState);
  }

  FutureOr<void> _onMessageSentToState(
    MessageSent event,
    Emitter<MessageSenderState> emit,
  ) async {
    try {
      emit(MessageSentInProgress());
      await messageRepository.sendMessage(message: event.message);
      emit(MessageSentSuccess());
    } on Exception catch (e, stackTrace) {
      log('Issue while sending message ${e.toString()} $stackTrace');
      emit(MessageSentFailure(message: e.toString()));
    }
  }
}
