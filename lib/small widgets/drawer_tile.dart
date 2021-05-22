import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  DrawerTile(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.only(left: 30),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange, Colors.amber],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
