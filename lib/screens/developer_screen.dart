import 'package:flutter/material.dart';
import 'package:wallpaper/screens/tabscreen.dart';

class StackContainer extends StatelessWidget {
  const StackContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                      'assets/images/profile.jpg',
                    )),
                SizedBox(height: 4.0),
                Text(
                  "Reuben Jefwa",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Developer",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(TabScreen.routeName);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 150);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomeView extends StatefulWidget {
  static const routeName = '/about-developer';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StackContainer(),
            SizedBox(
              height: 60,
            ),
            Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                    height: 250,
                    width: 330,
                    child: Card(
                        elevation: 5,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 14),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'First name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Last name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Email address',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Phone number',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                              //................Details
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 14),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Reuben',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Jefwa', style: TextStyle(fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('mrreubenyt@gmail.com',
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('+254796660187',
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
                Positioned(
                  top: -20,
                  right: 80,
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Card(
                      elevation: 5,
                      child: Center(
                        child: Text(
                          'PERSONAL',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
