// updates_page.dart
import 'package:flutter/material.dart';

class UpdatesPage extends StatelessWidget {
  const UpdatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10, // Replace with your friends' stories count
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
                // Add friends' profile images here
                ),
            title: Text('Friend ${index + 1}'),
            subtitle: const Text('Friend story details'),
            onTap: () {
              // Implement story viewing functionality
            },
          );
        },
      ),
    );
  }
}
