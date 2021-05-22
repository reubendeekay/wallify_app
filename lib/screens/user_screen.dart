import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper/loaders/colorloader2.dart';
import 'package:wallpaper/providers/darkmode.dart';
import 'package:wallpaper/screens/developer_screen.dart';
import 'package:wallpaper/small%20widgets/user_settings.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user-screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var _isTap = true;

  void isTapped() {
    setState(() {
      _isTap = !_isTap;
    });
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mrreubenyt@gmail.com',
      queryParameters: {
        'subject': 'Hello Reuben, I have the following query:\n'
      });
  void sendEmail() {
    launch(_emailLaunchUri.toString());
  }

  final userId = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? ColorLoader4(
              dotOneColor: Colors.deepOrange,
              dotTwoColor: Colors.blue,
              dotThreeColor: Colors.amber)
          : SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: size.width,
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(180),
                                  bottomRight: Radius.circular(180)),
                              gradient: LinearGradient(
                                  colors: [Colors.deepOrange, Colors.orange],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft)),
                        ),
                        Positioned(
                          top: size.height * 0.27,
                          left: size.width * 0.33,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data['image_url']),
                            radius: 70,
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.422,
                          left: size.width * 0.6,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 60,
                    width: 240,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [Colors.deepOrange, Colors.orange],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data['username'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Status:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('online',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  //..........Account details
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    constraints: BoxConstraints(minHeight: _isTap ? 60 : 130),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.grey[200],
                        borderRadius: BorderRadius.circular(30)),
                    width: 350,
                    height: _isTap ? 60 : 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Account details'),
                          trailing: IconButton(
                            icon: Icon(Icons.keyboard_arrow_down_sharp),
                            onPressed: isTapped,
                          ),
                        ),
                        AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                            //constraints: BoxConstraints(minHeight: _isTap ? 0 : 30),
                            height: _isTap ? 0 : 65,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email\t:${snapshot.data['email']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Username:${snapshot.data['username']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                    onTap: sendEmail,
                    child: UserSetting(
                        Icon(Icons.help_outline_rounded), 'Help and support'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed(HomeView.routeName),
                      child: UserSetting(
                          Icon(Icons.phone_android), 'About the developer')),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      var auth = FirebaseAuth.instance;
                      auth.signOut();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30)),
                      width: 200,
                      child: ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                        ),
                        title: Text(
                          'Sign out',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    ));
  }
}
