import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wallpaper/providers/darkmode.dart';
import 'package:wallpaper/screens/dayswallpaper.dart';
import 'package:wallpaper/screens/wallpaper_list_screen.dart';
import 'package:wallpaper/small%20widgets/drawer_tile.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            SizedBox(
              height: 23,
            ),
            GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(WallpaperListScreen.routeName),
                child: DrawerTile('Overview')),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.deepOrange, Colors.amber],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                      activeColor: Colors.amber,
                      value: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      })
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(DaysWallpaper.routeName);
                },
                child: DrawerTile('Wallpapers of the day')),
            SizedBox(
              height: 20,
            ),
            DrawerTile('Favourites'),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: DrawerTile('Log out')),
          ],
        ),
      ),
    );
  }
}
