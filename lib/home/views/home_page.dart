import 'package:app_chat/home/home.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/registration/data/models/app_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contact/contact.dart';
import '../../login/login.dart';

class HomePage extends StatelessWidget {
  final AppUser authenticatedUser;
  const HomePage({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: HomeView(
        authenticatedUser: authenticatedUser,
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  final AppUser authenticatedUser;
  const HomeView({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('homeAppBarTitle'),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).add(LoginRemoved());
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: _homeBodyBuilder(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedItem,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_rounded),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _homeBodyBuilder(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeContacts) {
          return ContactPage(authenticatedUser: widget.authenticatedUser);
        // } else if (state is HomeChat) {
        //   return ChatPage(
        //     authenticatedUser: widget.authenticatedUser,
        //   );
        } else {
          return Center(
            child: Text('You are ${widget.authenticatedUser.displayName}'),
          );
        }
      },
    );
  }

  void _onBottomNavTapped(int value) {
    if (value == 0) {
      BlocProvider.of<HomeBloc>(context).add(HomeContactTapped());
    } else if (value == 1) {
      BlocProvider.of<HomeBloc>(context).add(HomeChatTapped());
    } else {
      BlocProvider.of<HomeBloc>(context).add(HomeProfileTapped());
    }
    setState(() => selectedItem = value);
  }
}
