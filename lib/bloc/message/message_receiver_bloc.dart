import '../../connect/import_models.dart';
import '../../connect/import_package.dart';
import '../../connect/import_repository.dart';

part 'message_receiver_event.dart';
part 'message_receiver_state.dart';

class MessageReceiverBloc
    extends Bloc<MessageReceiverEvent, MessageReceiverState> {
  final MessageRepository messageRepository;
  late final StreamSubscription? messageStream;

  MessageReceiverBloc({
    required this.messageRepository,
  }) : super(MessageReceiverInitial()) {
    on<MessageRequested>(_onMessageRequestedToState);
    on<MessageReceived>(_onMessageReceivedToState);
  }

  @override
  Future<void> close() {
    messageStream?.cancel();
    return super.close();
  }

  FutureOr<void> _onMessageRequestedToState(
    MessageRequested event,
    Emitter<MessageReceiverState> emit,
  ) {
    try {
      emit(MessageLoadInProgress());
      messageStream = messageRepository
          .getMessages(conversationId: event.conversationId)
          .listen((messages) {
        add(MessageReceived(messages: messages));
      });
    } on Exception catch (e, trace) {
      log('Issue while loading message $e $trace');
      emit(MessageLoadFailure(message: e.toString()));
    }
  }

  FutureOr<void> _onMessageReceivedToState(
    MessageReceived event,
    Emitter<MessageReceiverState> emit,
  ) {
    emit(MessageLoadSuccess(messages: event.messages));
  }
}
