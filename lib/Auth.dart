import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/encrypter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Data with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  File _profileimage = File(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png");
  final ImagePicker _imagePicker = ImagePicker();

  void snackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
        ],
      ),
      duration: const Duration(seconds: 2),
    ));
  }

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

  Future<void> addMessage(String text, String friend_user_id) async {
    await _db
        .collection("chats")
        .doc(groupId(friend_user_id))
        .collection(groupId(friend_user_id))
        .add({
      "message": Encrypt.encryptAES(text),
      "time": Timestamp.now(),
      "user_id": _auth.currentUser!.uid,
    });
  }

  Future<String> getUrlStorage() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.putFile(_profileimage);

    final url = await ref.getDownloadURL();
    return url;
  }

  Future<void> createUser(String email, String password, BuildContext context,
      String userName) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBar(context, 'Please enter a Strong Password');
      } else if (e.code == 'email-already-in-use') {
        snackBar(context, "There is a already account in this e-mail");
      }
    } catch (e) {
      snackBar(context, e.toString());
    }
    try {
      await _db.collection("user").doc(_auth.currentUser!.uid).set({
        "user_name": userName,
        "user_id": _auth.currentUser!.uid,
        "profile_url": await getUrlStorage()
      });
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> signin(
      String username, String password, BuildContext context) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar(context, "User not Found");
      } else if (e.code == 'wrong-password') {
        snackBar(context, "You have enter a wrong password");
      }
    }

    notifyListeners();
  }

  Future<void> signout(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {}

    notifyListeners();
  }

  Future<void> DeleteChats(String frnduserId) async {
    try {
      await _db
          .collection('chats')
          .doc(frnduserId)
          .collection(frnduserId)
          .get()
          .then((value) => {
                value.docs.forEach((element) {
                  element.reference.delete();
                })
              });
    } catch (e) {}

    notifyListeners();
  }

  Future<File> setProfileImage() async {
    var image = (await _imagePicker.pickImage(
        imageQuality: 20, source: ImageSource.gallery))!;
    _profileimage = File(image.path);
    return _profileimage;
  }

  Future<void> deleteUser(BuildContext context) async {
    final userId = _auth.currentUser!.uid;

    try {
      await FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('$userId.jpg')
          .delete(); // deleting the profile pic
    } on FirebaseStorage catch (e) {
    } finally {
      final userlist = await _db.collection('user').get();
      var list = userlist.docs.toList(); // list of user

      list.forEach((element) async {
        // deleting the chat peers

        await _db
            .collection('chats')
            .doc(groupId(element['user_id']))
            .collection(groupId(element['user_id']))
            .get()
            .then((value) => {
                  value.docs.forEach((val) {
                    val.reference.delete();
                  })
                });
      });
    }

    try {
      await _db.collection('user').doc(_auth.currentUser!.uid).delete();
    } on FirebaseStorage catch (e) {
      rethrow;
    }
    try {
      await _auth.currentUser!.delete();
    } on FirebaseStorage catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateProfile(String userName, File image) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.delete();
    await ref.putFile(image);
    final url = await ref.getDownloadURL();

    await _db.collection("user").doc(_auth.currentUser!.uid).set({
      "user_name": userName,
      "user_id": _auth.currentUser!.uid,
      "profile_url": url
    });
    notifyListeners();
  }
}
