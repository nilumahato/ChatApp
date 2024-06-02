import 'dart:developer';
import 'package:bolchaal/api/api.dart';
import 'package:bolchaal/widgets/calls_page.dart';
import 'package:bolchaal/widgets/chat_home.dart';
import 'package:bolchaal/widgets/more_page.dart';
import 'package:bolchaal/widgets/update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation or other actions based on the index.
    });
  }

  Widget _buildFAB(int index) {
    if (index == 0) {
      return FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      );
    }
    return const SizedBox(); // Return an empty SizedBox if FAB is not needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _getPage(_selectedIndex),
      floatingActionButton: _buildFAB(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update),
            label: 'Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const ChatUserCard();
      case 1:
        return const CallsPage();
      case 2:
        return const UpdatesPage();
      case 3:
        return const MorePage();
      default:
        return const ChatUserCard(); // Or any default page
    }
  }
}
