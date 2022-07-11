import 'package:app_chat/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../conversation/conversation.dart';
import '../../registration/registration.dart';


class ChatPage extends StatelessWidget {
  final AppUser authenticatedUser;
  const ChatPage({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        chatRepository: ChatRepository(
          chatFirebaseProvider:
              ChatFirebaseProvider(fireStore: FirebaseFirestore.instance),
        ),
      )..add(ChatRequested(loginUID: authenticatedUser.uid)),
      child: _ChatView(
        authenticatedUser: authenticatedUser,
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final AppUser authenticatedUser;
  const _ChatView({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoadInProgress) {
            return const CircularProgressIndicator();
          } else if (state is ChatLoadFailure) {
            return const Text('Unable to load chats');
          } else if (state is ChatLoadSuccess) {
            return _ChatList(
              authenticatedUser: authenticatedUser,
              chats: state.chats,
            );
          }
          return Text(
            'Undefined state ${state.runtimeType.toString()}',
          );
        },
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final List<Conversation> chats;
  const _ChatList({
    Key? key,
    required this.chats,
    required this.authenticatedUser,
  }) : super(key: key);

  final AppUser authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty
        ? const Text("No chats yet. Go to contact and start conversation.")
        : ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = chats.elementAt(index);
              final receiver = chat.creator.uid != authenticatedUser.uid
                  ? chat.creator
                  : chat.receiver;
              return _ChatBody(
                receiver: receiver,
                authenticatedUser: authenticatedUser,
              );
            },
          );
  }
}

class _ChatBody extends StatelessWidget {
  final AppUser receiver;
  final AppUser authenticatedUser;

  const _ChatBody({
    Key? key,
    required this.receiver,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(receiver.photoUrl),
      ),
      title: Text(receiver.displayName),
      subtitle: Text(receiver.email),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () {
          Navigator.push<MaterialPageRoute>(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationPage(
                receiver: receiver,
                sender: authenticatedUser,
              ),
            ),
          );
        },
      ),
    );
  }
}
