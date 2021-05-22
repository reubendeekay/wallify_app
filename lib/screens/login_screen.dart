import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/providers/darkmode.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey<FormState>();
  String email = '';
  String username = '';
  String password = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential user;
  var message;

  File _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void trySubmit() {
    if (_key.currentState.validate()) {
      if (_isLogin) {
        _key.currentState.save();
        _trySignIn();
      } else if (!_isLogin && _image != null) {
        _key.currentState.save();
        _trySignIn();
      }
    }

    FocusScope.of(context).unfocus();
  }

  void _trySignIn() async {
    if (_isLogin) {
      try {
        user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } on PlatformException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    } else {
      try {
        user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(user.user.uid + '.jpg');

        await ref.putFile(_image);
        final url = await ref.getDownloadURL();

        FirebaseFirestore.instance.collection('users').doc(user.user.uid).set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      } on PlatformException catch (e) {
        print(e);
      } catch (e) {
        print(e);
      }
    }
  }

  var _isLogin = true;
  Animation<double> _opacityAnimation;
  AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    return Scaffold(
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 310,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await getImage();
                      },
                      child: Container(
                        child: _isLogin
                            ? CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/icon.png'),
                                radius: 40,
                                backgroundColor:
                                    isDark ? Colors.black : Colors.white,
                              )
                            : isDark
                                ? CircleAvatar(
                                    backgroundImage: _image == null
                                        ? AssetImage(
                                            'assets/images/profile1.png')
                                        : FileImage(_image),
                                    radius: 40,
                                    backgroundColor: Colors.orange,
                                  )
                                : Icon(
                                    Icons.person_pin,
                                    size: 90,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomEnd,
                      margin: EdgeInsets.only(right: 40),
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.deepOrange,
                      Colors.orange,
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(120))),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 50,
                width: 330,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (value.length < 6) {
                        return 'Please enter a valid email address';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      return email = value;
                    },
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
                        hintText: '\t\t\t\tEmail',
                        border: InputBorder.none),
                  ),
                ),
              ),
              if (!_isLogin)
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Container(
                    margin: EdgeInsets.only(top: _isLogin ? 0 : 20),
                    height: 50,
                    width: 330,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter  a username';
                          }
                          if (value.length < 4) {
                            return 'Username cannot be less than 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          return username = value;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                            hintText: '\t\t\t\Username',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 330,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.bottom,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an password';
                      }
                      if (value.length < 7) {
                        return 'Password cannot be less than 7 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      return password = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
                        hintText: '\t\t\t\Password',
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 32),
                child: Row(
                  children: [Spacer(), Text('Forgot password?')],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              GestureDetector(
                onTap: () {
                  trySubmit();
                  if (!_isLogin)
                  // Scaffold.of(context)
                  //     .showSnackBar(SnackBar(content: Text(message)));
                  if (_image == null)
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text('Please add a profile picture'),
                              content: Text(
                                  'To add a profile picture, click the icon above and select a picture'),
                              actions: [
                                FlatButton(
                                    onPressed: Navigator.of(context).pop,
                                    child: Text(
                                      'Okay',
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ))
                              ],
                            ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orange],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft)),
                  height: 45,
                  width: 330,
                  child: Center(
                      child: Text(
                    _isLogin ? 'LOGIN' : 'SIGNUP',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isLogin
                      ? 'Dont have an account?'
                      : 'Already have an account'),
                  SizedBox(
                    width: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                      if (_isLogin) {
                        setState(() {
                          _controller.reverse();
                        });
                      }
                      if (!_isLogin) {
                        _controller.forward();
                      }
                    },
                    child: Text(
                      _isLogin ? 'Register' : 'Log in',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
