import 'package:app_chat/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../registration/registration.dart';

class ChatPage extends StatelessWidget {
  final AppUser authenticatedUser;
  const ChatPage({Key? key, required this.authenticatedUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        chatRepository: ChatRepository(
          chatFirebaseProvider:
              ChatFirebaseProvider(fireStore: FirebaseFirestore.instance),
        ),
      )..add((ChatRequested(loginUID: authenticatedUser.uid))),
      child: _ChatView(
        authenticatedUser: authenticatedUser,
      ),
    );
  }
}

class _ChatView extends StatelessWidget {
  final AppUser authenticatedUser;
  const _ChatView({Key? key, required this.authenticatedUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {}
}
