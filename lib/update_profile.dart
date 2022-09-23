import 'dart:io';

import 'package:firebase/Auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdatePro extends StatefulWidget {
  static const updateProf = '/update';
  const UpdatePro({super.key});

  @override
  State<UpdatePro> createState() => _UpdateProState();
}

class _UpdateProState extends State<UpdatePro> {
  final ImagePicker _imagePicker = ImagePicker();
  bool isLoading = false;
  File? _profileimage;
  final TextEditingController _controller = TextEditingController();
  String newUsername = "Enter New UserName";
  String url =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png";

  void getImage() async {
    var image = (await _imagePicker.pickImage(
        imageQuality: 30, source: ImageSource.gallery))!;
    setState(() {
      _profileimage = File(image.path);
    });
  }

  void updateUsername(String username) {
    setState(() {
      newUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundColor: const Color(0xFF1E2A56),
                  child: CircleAvatar(
                      radius: 85,
                      backgroundColor: const Color(0xFF1E2A56),
                      backgroundImage: (_profileimage != null)
                          ? FileImage(File(_profileimage!.path))
                          : NetworkImage(url) as ImageProvider),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  newUsername,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        label: const Text("UserName"),
                        iconColor: const Color(0xFF1E2A56),
                        hintText: "Enter the New Username",
                      )),
                ),
                const SizedBox(
                  height: 40,
                ),
                OutlinedButton(
                  onPressed: (() {
                    getImage();
                  }),
                  child: const Text("Update Profile Image"),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: (() {
                    updateUsername(_controller.text);
                    _controller.clear();
                  }),
                  child: const Text("Update UserName"),
                ),
                const SizedBox(
                  height: 10,
                ),
                (isLoading == false)
                    ? OutlinedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await Provider.of<Data>(context, listen: false)
                              .updateProfile(newUsername, _profileimage!);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text("SUBMIT"))
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
