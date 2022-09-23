import 'package:firebase/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/bubble_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chatscreen extends StatelessWidget {
  final String text = "";
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  static const chatpage = '/chat-page';
  var _frnduserId = "";

  String groupId(String friend_user_id) {
    String group_id = "";
    String user_id = _auth.currentUser!.uid;

    if (_auth.currentUser!.uid.hashCode >= friend_user_id.hashCode) {
      group_id = '$user_id-$friend_user_id';
    } else {
      group_id = '$friend_user_id-$user_id';
    }

    return group_id;
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    var userName = args['userName'] as String;
    _frnduserId = args['frndId'] as String;
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2A56),
                  ),
                  child: SizedBox.shrink()),
              ListTile(
                tileColor: Colors.white10,
                leading: const Icon(Icons.delete),
                title: const Text(
                  "Delete Chats",
                  style: TextStyle(fontSize: 17),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text("Are You Sure?"),
                      actions: [
                        TextButton(
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: const Text("NO",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        TextButton(
                            onPressed: () {
                              Provider.of<Data>(context, listen: false)
                                  .DeleteChats(groupId(_frnduserId))
                                  .then((value) => Navigator.of(context).pop());
                            },
                            child: const Text("YES",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            userName,
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(groupId(_frnduserId))
                    .collection(groupId(_frnduserId))
                    .orderBy('time', descending: true)
                    .limit(100)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Chats Present"),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs.toList();
                            return Message(
                              data[index]['message'],
                              _auth.currentUser!.uid == data[index]['user_id'],
                            );
                          },
                        ),
                      );
                    }
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: "Enter the message here",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gapPadding: 2)),
                  ),
                )),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send_sharp),
                  onPressed: () {
                    String text = _controller.text;
                    if (text.isNotEmpty) {
                      Provider.of<Data>(context, listen: false)
                          .addMessage(text, _frnduserId);
                      _controller.clear();
                    }
                  },
                ),
              ],
            )
          ],
        ));
  }
}
