import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Auth.dart';
import 'package:firebase/Chat_Screen.dart';
import 'package:firebase/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF1E2A56),
                  Color.fromARGB(255, 26, 49, 62)
                ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      } else {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!['profile_url']),
                              foregroundColor: Colors.cyan,
                              radius: 55,
                            ),
                            Text(
                              snapshot.data!['user_name'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Sign Out"),
                onTap: () {
                  Provider.of<Data>(context, listen: false).signout(context);
                }),
            ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text("Delete Account"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Are you Sure?"),
                      actions: [
                        TextButton(
                          child: const Text("NO",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                            onPressed: (() {
                              Provider.of<Data>(context, listen: false)
                                  .deleteUser(context);
                              Navigator.of(context).pop();
                            }),
                            child: const Text("YES",
                                style: TextStyle(fontWeight: FontWeight.bold)))
                      ],
                    ),
                  );
                }),
            ListTile(
              leading: const Icon(Icons.update_sharp),
              title: const Text("Update Profile"),
              onTap: () {
                //prof = [_profImage, _userName];

                Navigator.of(context).pushNamed(
                  UpdatePro.updateProf,
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Members",
          style: Theme.of(context).textTheme.headline1,
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("user").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data Present"),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs.toList();
                            if (userId != data[index]['user_id']) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        data[index]['profile_url']),
                                    radius: 30,
                                    backgroundColor: const Color(0xFF1E2A56),
                                  ),
                                  onTap: () {
                                    var userData = {
                                      'userName': data[index]['user_name'],
                                      'frndId': data[index]['user_id']
                                    };
                                    Navigator.of(context).pushNamed(
                                        chatscreen.chatpage,
                                        arguments: userData);
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      data[index]['user_name'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
