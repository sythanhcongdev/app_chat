import '../../connect/import_models.dart';
import '../../connect/import_provider.dart';

class RegistrationRepository{
  final RegistrationFirebaseProvider registrationFirebaseProvider;

  RegistrationRepository({required this.registrationFirebaseProvider});

  Future<AppUser?> getUserDetails({required String uid}) async{
    final userMapFromFirebase = await registrationFirebaseProvider.getUserDetails(uid: uid);
    return userMapFromFirebase == null ?null:AppUser.fromMap(userMapFromFirebase);
  }

  Future<void> registerUserDetails({required AppUser user }) async{
    await registrationFirebaseProvider.registerUser(user:  user.toMap());
  }
}