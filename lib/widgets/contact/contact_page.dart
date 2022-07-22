import '../../connect/import_bloc.dart';
import '../../connect/import_models.dart';
import '../../connect/import_package_page.dart';
import '../../connect/import_page.dart';
import '../../connect/import_provider.dart';
import '../../connect/import_repository.dart';


class ContactPage extends StatelessWidget {
  final AppUser authenticatedUser;
  const ContactPage({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactBloc(
        ContactRepository(
          contactFirebaseProvider:
              ContactFirebaseProvider(fireStore: FirebaseFirestore.instance),
        ),
      )..add(ContactListRequested(loginUID: authenticatedUser.uid)),
      child: ContactView(
        loginUser: authenticatedUser,
      ),
    );
  }
}

class ContactView extends StatelessWidget {
  final AppUser loginUser;
  const ContactView({
    Key? key,
    required this.loginUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoadInProgress) {
            return const CircularProgressIndicator();
          } else if (state is ContactLoadFailure) {
            return const Text('Unable to load contacts');
          } else if (state is ContactLoadSuccess) {
            return _contactListView(contacts: state.contacts);
          }
          return Text('Undefined state ${state.runtimeType}');
        },
      ),
    );
  }

  Widget _contactListView({required List<AppUser> contacts}) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        final contact = contacts.elementAt(index);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(contact.photoUrl),
          ),
          title: Text(contact.displayName),
          subtitle: Text(contact.email),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () {
              Navigator.push<MaterialPageRoute>(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationPage(
                    receiver: contact,
                    sender: loginUser,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
