import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter_chat/home/home.dart';

import 'package:app_chat/registration/bloc/registration_bloc.dart';
import 'package:app_chat/registration/registration.dart';

import '../../home/home.dart';


class RegistrationPage extends StatelessWidget {
  final AppUser authenticatedUser;
  const RegistrationPage({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(
        registrationRepository: RegistrationRepository(
          registrationFirebaseProvider: RegistrationFirebaseProvider(
            fireStore: FirebaseFirestore.instance,
          ),
        ),
      )..add(
          RegistrationDetailRequested(
            uid: authenticatedUser.uid,
          ),
        ),
      child: RegistrationView(authenticatedUser: authenticatedUser),
    );
  }
}


class RegistrationView extends StatelessWidget {
  final AppUser authenticatedUser;

  const RegistrationView({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: _registrationListener,
          buildWhen: (prev, current) {
            if (current is RegistrationActionFailure ||
                current is RegistrationActionError) {
              return false;
            }
            return true;
          },
          builder: _registrationBuilder,
        ),
      ),
    );
  }

  void _registrationListener(BuildContext context, RegistrationState state) {
    if (state is RegistrationActionFailure) {
      BlocProvider.of<RegistrationBloc>(context).add(
        RegistrationDetailUpdated(user: authenticatedUser),
      );
    } else if (state is RegistrationActionError) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Counter'),
        ),
      );
    }
  }

  Widget _registrationBuilder(BuildContext context, RegistrationState state) {
    if (state is RegistrationInProgress) {
      return const CircularProgressIndicator();
    } else if (state is RegistrationUpdateSuccess) {
      return HomePage(authenticatedUser: state.user);
    } else if (state is RegistrationDetailRequestSuccess) {
      return HomePage(authenticatedUser: state.user);
    }

    return Text('Undefined state ${state.runtimeType}');
  }
}
