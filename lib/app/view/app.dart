import 'package:app_chat/login/login.dart';
import 'package:app_chat/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:app_chat/registration/registration.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue.withOpacity(0.70),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.blue.withOpacity(0.70),
        ),
      ),
      home: BlocProvider(
        create: (context) => LoginBloc(
          loginRepository: LoginRepository(
            loginFirebaseProvider:
                LoginFirebaseProvider(firebaseAuth: FirebaseAuth.instance),
          ),
        )..add(LoginVerified()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginFailure) {
          return const LoginPage();
        } else if (state is LoginSuccess) {
          return RegistrationPage(authenticatedUser: state.user);
        } else if (state is LoginInProgress) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Text('Undefined state ${state.runtimeType}');
      },
    );
  }
}
