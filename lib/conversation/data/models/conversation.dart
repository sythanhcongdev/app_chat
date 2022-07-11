// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:app_chat/registration/data/models/app_user.dart';

import '../../../utilities/keys/conversation_keys.dart';

class Conversation extends Equatable {
  final String? id;
  final AppUser creator;
  final AppUser receiver;
  final List<String> members;
  const Conversation({
    this.id,
    required this.creator,
    required this.receiver,
    required this.members,
  });

  Conversation copyWith({
    String? id,
    AppUser? creator,
    AppUser? receiver,
    List<String>? members,
  }) {
    return Conversation(
      id: id ?? this.id,
      creator: creator ?? this.creator,
      receiver: receiver ?? this.receiver,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ConversationKeys.id: id,
      ConversationKeys.creator: creator.toMap(),
      ConversationKeys.receiver: receiver.toMap(),
      ConversationKeys.members: members,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map[ConversationKeys.id]?.toString(),
      creator:
          AppUser.fromMap(map[ConversationKeys.creator] as Map<String, dynamic>),
      receiver: AppUser.fromMap(
        map[ConversationKeys.receiver] as Map<String, dynamic>,
      ),
      members: List<String>.from(map[ConversationKeys.members] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Conversation(id: $id, creator: $creator, receiver: $receiver, members: $members)';
  }

  @override
  List<Object> get props => [creator, receiver, members];
}
