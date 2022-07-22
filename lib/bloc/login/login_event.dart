// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginWithGooglePressed extends LoginEvent {}

class LoginVerified extends LoginEvent {}

class LoginStateChanged extends LoginEvent {
  final AppUser? user ;
  LoginStateChanged({
     this.user,
  });
}
class  LoginRemoved extends LoginEvent{}
