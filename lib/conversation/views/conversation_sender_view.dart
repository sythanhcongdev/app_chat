import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_chat/message/bloc/message_sender_bloc.dart';
import 'package:app_chat/conversation/data/models/message.dart';

class ConversationSenderView extends StatefulWidget {
  final String? conversationId;
  final String senderUID;
  final String receiverUID;

  const ConversationSenderView({
    Key? key,
    this.conversationId,
    required this.receiverUID,
    required this.senderUID,
  }) : super(key: key);

  @override
  State<ConversationSenderView> createState() => _ConversationSenderViewState();
}

class _ConversationSenderViewState extends State<ConversationSenderView> {
  late final TextEditingController messageTextController;
  late String message;

  @override
  void initState() {
    super.initState();
    messageTextController = TextEditingController();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: TextField(
            controller: messageTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
            child: BlocConsumer<MessageSenderBloc, MessageSenderState>(
          listener: (context, state) {
            if (state is MessageSentSuccess) {
              setState(messageTextController.clear);
            }
          },
          builder: (context, state) {
            if (state is MessageSentInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MessageSentFailure) {
              return const Icon(
                Icons.error,
              );
            }
            return IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                message = messageTextController.text.trim();
                if (message.isNotEmpty) {
                  BlocProvider.of<MessageSenderBloc>(context).add(MessageSent(
                    message: Message(
                      content: message,
                      conversationId: widget.conversationId ?? '',
                      senderUID: widget.senderUID,
                      receiverUID: widget.receiverUID,
                      timeStamp:
                          DateTime.now().microsecondsSinceEpoch.toString(),
                    ),
                  ));
                }
              },
            );
          },
        )),
      ],
    );
  }
}
