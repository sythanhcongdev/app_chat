part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegistrationDetailRequested extends RegistrationEvent {
  final String uid;

  const RegistrationDetailRequested({required this.uid}); 
  @override
  List<Object> get props => [uid];
}

class RegistrationDetailUpdated extends RegistrationEvent {
  final AppUser user;

  const RegistrationDetailUpdated({required this.user});
  @override
  List<Object> get props => [user];
}

