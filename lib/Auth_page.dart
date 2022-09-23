import 'dart:io';

import 'package:firebase/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  bool _isLoading = false;
  bool _confirm = true;
  bool _createaccount = true;
  bool _pass = true;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpass = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  static const authpage = '/Authpage';
  File _image = File(
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png");

  AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void dispose() {
    widget._emailcontroller.dispose();
    widget._confirmpass.dispose();
    widget._passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var maxHeight = MediaQuery.of(context).size.height;
    var maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFF1E2A56),
        appBar: AppBar(
          title: Center(
              child: Text(
            "Flutter Chat",
            style: Theme.of(context).textTheme.headline1,
          )),
          elevation: 0,
        ),
        body: Center(
          child: AnimatedContainer(
            curve: Curves.easeInOutQuad,
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: maxHeight * ((widget._createaccount) ? 0.39 : 0.73),
            width: maxWidth * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Form(
                  key: widget._formkey,
                  child: Column(
                    children: [
                      if (!widget._createaccount)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CircleAvatar(
                            backgroundColor: const Color(0xFF1E2A56),
                            radius: 48,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFF1E2A56),
                              backgroundImage: FileImage(widget._image),
                              radius: 45,
                              child: IconButton(
                                  onPressed: () async {
                                    var image = await Provider.of<Data>(context,
                                            listen: false)
                                        .setProfileImage();
                                    setState(() {
                                      widget._image = File(image.path);
                                    });
                                  },
                                  icon: const Icon(Icons.add)),
                            ),
                          ),
                        ),

                      if (!widget._createaccount)
                        const Center(
                          child: Text(
                            "Add Profile Photo",
                            style: TextStyle(
                              color: Color(0xFF1E2A56),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                            validator: (value) {
                              if (value != null && !value.contains('@')) {
                                return 'Please enter valid email Id';
                              }
                              return null;
                            },
                            controller: widget._emailcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: const Icon(Icons.email),
                              label: const Text("Email"),
                              iconColor: const Color(0xFF1E2A56),
                              hintText: "Enter the Email",
                            )),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: TextFormField(
                            obscureText: widget._pass,
                            validator: (value) {
                              if (value == null) {
                                return 'Password cannot be left null';
                              } else if (value.length < 6) {
                                return 'Password should be of length 6 and special character and number';
                              }
                              return null;
                            },
                            controller: widget._passwordcontroller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              iconColor: const Color(0xFF1E2A56),
                              suffixIcon: IconButton(
                                icon: (widget._pass)
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    widget._pass = !widget._pass;
                                  });
                                },
                              ),
                              label: const Text("Password"),
                              hintText: "Enter the Password",
                            )),
                      ),

                      // build when user want to create new account
                      if (!widget._createaccount)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                              validator: (value) {
                                if (value != null &&
                                    widget._passwordcontroller.text !=
                                        widget._confirmpass.text) {
                                  return "Invalid Password";
                                }
                                return null;
                              },
                              obscureText: widget._confirm,
                              controller: widget._confirmpass,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                iconColor: const Color(0xFF1E2A56),
                                suffixIcon: IconButton(
                                  icon: (widget._confirm)
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      widget._confirm = !widget._confirm;
                                    });
                                  },
                                ),
                                label: const Text("Confirm Password"),
                                hintText: "Confirm Password",
                              )),
                        ),

                      if (!widget._createaccount)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            controller: widget._usernameController,
                            validator: ((value) {
                              if (value == null) {
                                return "Please Enter an UserName";
                              }
                              return null;
                            }),
                            decoration: InputDecoration(
                                hintText: "Username",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                iconColor: const Color(0xFF1E2A56),
                                suffixIcon: const Icon(Icons.verified_user)),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Switch between the Signin and signout widget
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (widget._createaccount)
                              ? (widget._isLoading)
                                  ? const CircularProgressIndicator()
                                  : OutlinedButton(
                                      child: const Text('LOGIN IN'),
                                      onPressed: () async {
                                        if (widget._formkey.currentState!
                                            .validate()) {
                                          String username = widget
                                              ._emailcontroller.text
                                              .trim();
                                          String password = widget
                                              ._passwordcontroller.text
                                              .trim();

                                          setState(() {
                                            widget._isLoading = true;
                                          });

                                          await Provider.of<Data>(context,
                                                  listen: false)
                                              .signin(
                                                  username, password, context);
                                          setState(() {
                                            widget._isLoading = false;
                                          });
                                        }
                                      },
                                    )
                              : (widget._isLoading)
                                  ? const CircularProgressIndicator()
                                  : OutlinedButton(
                                      child: const Text('SIGN UP'),
                                      onPressed: () async {
                                        if (widget._formkey.currentState!
                                            .validate()) {
                                          String email = widget
                                              ._emailcontroller.text
                                              .trim();
                                          String password = widget
                                              ._passwordcontroller.text
                                              .trim();
                                          String username =
                                              widget._usernameController.text;

                                          setState(() {
                                            widget._isLoading = true;
                                          });
                                          await Provider.of<Data>(context,
                                                  listen: false)
                                              .createUser(email, password,
                                                  context, username);
                                          setState(() {
                                            widget._isLoading = false;
                                          });
                                        }
                                      },
                                    ),

                          // switch the widget between the create account and Already have account

                          TextButton(
                            child: (widget._createaccount)
                                ? const Text("Create Account",
                                    style: TextStyle(
                                      color: Color(0xFF1E2A56),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ))
                                : const Text("Already Have Account",
                                    style: TextStyle(
                                      color: Color(0xFF1E2A56),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                            onPressed: () {
                              setState(() {
                                widget._createaccount = !widget._createaccount;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ));
  }
}
