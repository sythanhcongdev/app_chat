// ignore_for_file: public_member_api_docs, sort_constructors_first


import '../../../registration/data/models/app_user.dart';
import '../providers/login_firebase_provider.dart';

class LoginRepository {
  final LoginFirebaseProvider loginFirebaseProvider;
  LoginRepository({
    required this.loginFirebaseProvider,
  });

  Future<AppUser?> loginWithGoogle() async {
    final firebaseUser = await loginFirebaseProvider.loginWithGoogle();
    return firebaseUser == null
        ? null
        : AppUser(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            photoUrl: firebaseUser.photoURL ?? '',
          );
  }

  Stream<bool> isLoggedIn() {
    final streamOfUser = loginFirebaseProvider.getLoggedInUserStates();
    return streamOfUser.map((user) => user != null);
  }

  Stream<AppUser?> getLoggedInUser() {
    final loggedInUserStream = loginFirebaseProvider.getLoggedInUserStates();
    return loggedInUserStream.map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      } else {
        return AppUser(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL ?? '',
        );
      }
    });
  }

  Future<void> logOut() async {
    await loginFirebaseProvider.logOut();
  }
}
