import 'package:flutter/material.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/screens/wallpaper_details_screen.dart';
import 'package:wallpaper/widgets/picture.dart';

class MainStack extends StatelessWidget {
  final Picture _data;
  MainStack(this._data);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Pic(_data),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(WallpaperDetailScreen.routeName,
                arguments: _data.id);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 11),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                'Wallpapers of the  day',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 18,
                    letterSpacing: 2.5),
              ),
            ),
          ),
        )
      ],
    );
  }
}
