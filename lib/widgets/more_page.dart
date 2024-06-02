import 'package:bolchaal/Screens/profile_screen.dart';
import 'package:bolchaal/api/api.dart';
import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Implement settings page navigation
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Implement profile page navigation

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            user: APIs.me,
                          )));
            },
          ),
          const Divider(),
          // Add other options like help, about, etc.
        ],
      ),
    );
  }
}
