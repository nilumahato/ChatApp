import 'package:bolchaal/api/api.dart';
import 'package:bolchaal/main.dart';
import 'package:bolchaal/model/chat_user.dart';
import 'package:bolchaal/widgets/chats_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  //String? _image;
  //for storing all users
  List<ChatUser> _list = [];

  //for storing searched items
  final List<ChatUser> _searchList = [];

  //for storing search status
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        //if search is on & back button is pressed then close search
        //or else simple close current screen on back click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //app bar
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name, Email , ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    //when search text changes then update search list
                    onChanged: (val) {
                      // search logic
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text("BolChaal"),
            actions: [
              //for camera button
              // IconButton(
              //   onPressed: () async {
              //     final ImagePicker picker = ImagePicker();
              //     // Pick an image.
              //     final XFile? image = await picker.pickImage(
              //         source: ImageSource.camera, imageQuality: 80);
              //     if (image != null) {
              //       log('Image Path: ${image.path}');
              //       setState(() {
              //         _image = image.path;
              //       });

              //       APIs.updateProfilePicture(File(_image!));

              //       // for hiding bottom sheet
              //       Navigator.pop(context);
              //     }
              //   },
              //   icon: const Icon(Icons.camera_alt),
              // ),
              //search user buttom
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        itemBuilder: (context, index) {
                          return ChatPage(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
                        });
                  } else {
                    return const Center(
                      child: Text('No connection Found!',
                          style: TextStyle(fontSize: 20, color: Colors.brown)),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
