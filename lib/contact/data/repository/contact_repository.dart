import 'package:app_chat/contact/data/provider/contact_firebase_provider.dart';

import '../../../registration/registration.dart';

class ContactRepository {
  final ContactFirebaseProvider contactFirebaseProvider;

  ContactRepository({
    required this.contactFirebaseProvider,
  });

  Future<List<AppUser>> getContacts({required String loginUID}) async {
    final listUserMaps = await contactFirebaseProvider.getContacts(
      loginUID: loginUID,
    );
    return listUserMaps.map((userMap) => AppUser.fromMap(userMap)).toList();
  }
}
