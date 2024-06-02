import 'package:flutter/material.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calls'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Functionality to add users
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Contacts'),
              Tab(text: 'Recents'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contacts Tab View
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Replace with your contacts count
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                            // Add profile images here
                            ),
                        title: Text('Contact ${index + 1}'),
                        subtitle: const Text('Details'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.videocam),
                              onPressed: () {
                                // Implement video call functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.call),
                              onPressed: () {
                                // Implement calling functionality
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Implement contact tap functionality
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // Recents Tab View
            ListView(
              children: [
                const ListTile(
                  title: Text('Recent Calls'),
                ),
                ListTile(
                  leading: const CircleAvatar(
                      // Add profile image for recent call
                      ),
                  title: const Text('Contact Name'),
                  subtitle: const Text('5 times • 25 mins ago'),
                  trailing: const Icon(
                      Icons.call), // or Icon(Icons.videocam) for video call
                  onTap: () {
                    // Implement recent call tap functionality
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                      // Add profile image for recent call
                      ),
                  title: const Text('Another Contact'),
                  subtitle: const Text('3 times • 1 hour ago'),
                  trailing: const Icon(
                      Icons.videocam), // or Icon(Icons.call) for voice call
                  onTap: () {
                    // Implement recent call tap functionality
                  },
                ),
                // Add more recent call list items as needed
              ],
            ),
          ],
        ),
      ),
    );
  }
}
