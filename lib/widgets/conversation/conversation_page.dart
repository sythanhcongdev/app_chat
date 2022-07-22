import '../../connect/import_bloc.dart';
import '../../connect/import_models.dart';
import '../../connect/import_package_page.dart';
import '../../connect/import_page.dart';
import '../../connect/import_provider.dart';
import '../../connect/import_repository.dart';

class ConversationPage extends StatelessWidget {
  final String? converasationId;
  final AppUser sender;
  final AppUser receiver;

  const ConversationPage({
    Key? key,
    this.converasationId,
    required this.sender,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationBloc(
        conversationRepository: ConversationRepository(
          conversationFirebaseProvider: ConversationFirebaseProvider(
            fireStore: FirebaseFirestore.instance,
          ),
        ),
      )..add(
          ConversationDetailRequested(
            loginUser: sender,
            receiver: receiver,
          ),
        ),
      child: ConversationView(
        loginUser: sender,
        receiver: receiver,
      ),
    );
  }
}

class ConversationView extends StatelessWidget {
  final AppUser loginUser;
  final AppUser receiver;

  const ConversationView({
    Key? key,
    required this.loginUser,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.displayName),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(receiver.photoUrl),
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoadSuccess) {
              return ConversationMainView(
                loginUser: loginUser,
                receiver: receiver,
                conversationId: state.conversation.id ?? '',
              );
            } else if (state is ConversationCreationSuccess) {
              return ConversationMainView(
                loginUser: loginUser,
                receiver: receiver,
                conversationId: state.conversationId,
              );
            } else if (state is ConversationLoadInProgress ||
                state is ConversationCreationInProgress) {
              return const CircularProgressIndicator();
            } else if (state is ConversationLoadFailure ||
                state is ConversationCreationFailure) {
              return const Text('We are unable to load conversation. Please try again.');
            }
            return Text('Undefined state ${state.runtimeType}');
          },
        ),
      ),
    );
  }
}
