import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Auth.dart';
import 'package:firebase/Chat_Screen.dart';
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
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1E2A56),
                ),
                child: ListTile(
                  iconColor: Colors.white,
                  tileColor: Colors.white10,
                  leading: Icon(Icons.settings, size: 40),
                  title: Text(
                    "Settings",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
            ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Sign Out"),
                onTap: () {
                  Provider.of<Data>(context, listen: false).signout(context);
                })
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Members",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ],
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
                            return (userId != data[index]['user_id'])
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            data[index]['profile_url']),
                                        radius: 30,
                                        backgroundColor:
                                            const Color(0xFF1E2A56),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            chatscreen.chatpage,
                                            arguments: data[index]['user_id']);
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
                                  )
                                : const SizedBox.shrink();
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
