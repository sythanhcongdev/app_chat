import '../../connect/import_models.dart';
import '../../connect/import_package.dart';
import '../../connect/import_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  ChatBloc({
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<ChatRequested>(_onChatRequestedToState);
  }

  FutureOr<void> _onChatRequestedToState(
    ChatRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoadInProgress());
      final chats = await chatRepository.getChats(loginUID: event.loginUID);
      emit(ChatLoadSuccess(chats: chats));
    } on Exception catch (e, trace) {
      log('Issue occrued while loading chats $e $trace ');
      emit(const ChatLoadFailure(message: 'unable to load chats'));
    }
  }
}
