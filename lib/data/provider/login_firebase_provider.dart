// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginFirebaseProvider {
  final FirebaseAuth firebaseAuth;
  LoginFirebaseProvider({
    required this.firebaseAuth,
  });

  Future<User?> loginWithGoogle() async {
    final googleSignInAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleSignInAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential = await firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Stream<User?> getLoggedInUserStates(){
    return firebaseAuth.authStateChanges();
  }

  Future<void> logOut() async{
    await GoogleSignIn().signOut();
    await firebaseAuth.signOut();
  }
}
