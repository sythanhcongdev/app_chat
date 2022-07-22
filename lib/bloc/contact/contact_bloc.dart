import '../../connect/import_models.dart';
import '../../connect/import_package.dart';
import '../../connect/import_repository.dart';


part 'contact_event.dart';
part 'contact_state.dart';


class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository contactRepository;

  ContactBloc(
    this.contactRepository,
  ) : super(ContactInitial()) {
    on<ContactListRequested>(_onContactListRequested);
  }

  FutureOr<void> _onContactListRequested(
    ContactListRequested event,
    Emitter<ContactState> emit,
  ) async {
    try {
      emit(ContactLoadInProgress());
      final contacts =
          await contactRepository.getContacts(loginUID: event.loginUID);
      emit(ContactLoadSuccess(contacts: contacts));
    } catch (e) {
      log('Issue while loading contacts ${e.toString()}');
      emit(const ContactLoadFailure(message: 'Unable to load contacts'));
    }
  }
}
