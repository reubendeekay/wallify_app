import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/loaders/colorloader4.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/screens/drawer.dart';
import 'package:wallpaper/widgets/picture.dart';

class DaysWallpaper extends StatelessWidget {
  static const routeName = 'wallpapers-of-the-day';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wallpapers of the Day'),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<ImagesProvider>(context, listen: false).getImages(),
            builder: (ctx, snapshot) {
              final imageData =
                  Provider.of<ImagesProvider>(context, listen: false);
              return snapshot.connectionState == ConnectionState.waiting
                  ? ColorLoader5(
                      dotType: DotType.circle,
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.blue,
                      dotThreeColor: Colors.amber,
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, i) {
                        return Container(
                            height: 600,
                            child: Pic(imageData
                                .image[i + (imageData.image.length - 21)]));
                      },
                      itemCount: 21,
                    );
            }));
  }
}
