import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallpaper/screens/user_screen.dart';
import 'package:wallpaper/screens/wallpaper_list_screen.dart';

class TabScreen extends StatefulWidget {
  static const routeName = '/tab-screen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedIndex = 0;
  final widgetOptions = [
    WallpaperListScreen(),
    UserScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 40,
        child: BottomNavigationBar(
          selectedFontSize: 10,
          selectedIconTheme: IconThemeData(size: 16),
          unselectedIconTheme: IconThemeData(size: 12),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Beers'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          ],
          currentIndex: selectedIndex,
          fixedColor: Colors.deepOrange,
          onTap: onItemTapped,
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
