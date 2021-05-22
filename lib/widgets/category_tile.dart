import 'package:flutter/material.dart';
import 'package:wallpaper/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  CategoryTile(this.title);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategoryScreen.routeName, arguments: title);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [Colors.red, Colors.deepOrange, Colors.amber],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        height: 50,
        width: 120,
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        )),
      ),
    );
  }
}
