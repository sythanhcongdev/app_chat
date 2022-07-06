import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_receiver_event.dart';
part 'message_receiver_state.dart';

class MessageReceiverBloc extends Bloc<MessageReceiverEvent, MessageReceiverState> {
  MessageReceiverBloc() : super(MessageReceiverInitial()) {
    on<MessageReceiverEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
