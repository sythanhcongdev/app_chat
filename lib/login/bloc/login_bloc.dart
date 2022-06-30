import 'dart:developer';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../registration/data/models/app_user.dart';
import '../data/repositories/login_repositories.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.loginRepository,
  }) : super(LoginInitial()) {
    on<LoginWithGooglePressed>(_onLoginWithGoogle);
    on<LoginVerified>(_onLoginVerified);
    on<LoginStateChanged>(_onLoginStateChanged);
    on<LoginRemoved>(_onLoginRemoved);
  }
  final LoginRepository loginRepository;
  late StreamSubscription isLoginStates;

  @override
  Future<void> close() {
    isLoginStates.cancel();
    return super.close();
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginInProgress());
      final authenticatedUser = await loginRepository.loginWithGoogle();
      log('the logged in user is ${authenticatedUser?.displayName}');
      emit(
        authenticatedUser == null
            ? LoginFailure()
            : LoginSuccess(user: authenticatedUser),
      );
    } catch (any) {
      log('Issue occurred while login with google ${any.toString()}');
      emit(LoginFailure());
    }
  }

  void _onLoginVerified(LoginVerified event, Emitter<LoginState> emit) {
    try {
      emit(LoginInProgress());
      isLoginStates = loginRepository.getLoggedInUser().listen((user) {
        add(LoginStateChanged(user: user));
      });
    } catch (e) {
      log('Issue  while checking for authentication state ${e.toString()}');
      emit(LoginFailure());
    }
  }

  FutureOr<void> _onLoginStateChanged(
     LoginStateChanged event,
    Emitter<LoginState> emit,
  ){
    final user = event.user;
    emit(user == null?LoginFailure(): LoginSuccess(user: user));
  }

  FutureOr<void> _onLoginRemoved(
    LoginRemoved event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginInProgress());
      await loginRepository.logOut();
    } catch (e) {
      log('Unexpected error occurred while logout ${e.toString()}');
      LoginFailure();
    }
  }
}
