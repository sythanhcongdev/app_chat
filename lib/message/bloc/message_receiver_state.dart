part of 'message_receiver_bloc.dart';

abstract class MessageReceiverState extends Equatable {
  const MessageReceiverState();
  
  @override
  List<Object> get props => [];
}

class MessageReceiverInitial extends MessageReceiverState {}

class MessageLoadSuccess extends MessageReceiverState {}

class MessageLoadInProgress extends MessageReceiverState {}

class MessageLoadFailure extends MessageReceiverState {}