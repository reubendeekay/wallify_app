import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:wallpaper/loaders/colorloader3.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/screens/wallpaper_details_screen.dart';

class Pic extends StatelessWidget {
  final Picture pic;

  Pic(this.pic);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(WallpaperDetailScreen.routeName, arguments: pic.id);
      },
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 160,
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: pic.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: ColorLoader3(
                    dotRadius: 6.0,
                    radius: 15.0,
                  ))
                  // CircularProgressIndicator(
                  //   value: downloadProgress.progress,
                  //   strokeWidth: 20,
                  // ),
                  ,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
          )),
    );
  }
}
