import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../registration.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegistrationRepository registrationRepository;
  RegistrationBloc({required this.registrationRepository})
      : super(RegistrationInitial()) {
    on<RegistrationDetailRequested>(_onRegistrationDetailRequestedToState);
    on<RegistrationDetailUpdated>(_onRegistrationUpdatedToState);
  }

  FutureOr<void> _onRegistrationDetailRequestedToState(
    RegistrationDetailRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationInProgress());
      final user = await registrationRepository.getUserDetails(uid: event.uid);
      emit(
        user == null
            ? const RegistrationActionFailure(message: 'user not found')
            : RegistrationDetailRequestSuccess(user: user),
      );
    } catch (e) {
      log('Unexpected error occurred ${e.toString()}');
      emit(
        const RegistrationActionError(
          message: 'Error occurred while searching',
        ),
      );
    }
  }

  FutureOr<void> _onRegistrationUpdatedToState(
    RegistrationDetailUpdated event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationInProgress());
      await registrationRepository.registerUserDetails(user: event.user);
      emit(RegistrationUpdateSuccess(user: event.user));
    } catch (e) {
      log('Error occurred while updating user detail ${e.toString()}');
      emit(
        const RegistrationActionError(message: 'error occurred while updating'),
      );
    }
  }
}
