import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/loaders/colorloader2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/screens/drawer.dart';
import 'package:wallpaper/screens/search_screen.dart';

import 'package:wallpaper/small%20widgets/stack.dart';
import 'package:wallpaper/widgets/category_tile.dart';
import 'package:wallpaper/widgets/picture.dart';

class WallpaperListScreen extends StatefulWidget {
  static const routeName = 'overview';
  @override
  _WallpaperListScreenState createState() => _WallpaperListScreenState();
}

class _WallpaperListScreenState extends State<WallpaperListScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero)
  //       .then((value) => Provider.of<ImagesProvider>(context).getImages());
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Text(
            'Wallpapers',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<ImagesProvider>(context, listen: false).getImages(),
          builder: (ctx, snapshot) {
            var data =
                Provider.of<ImagesProvider>(context, listen: false).image;
            return snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData
                ? Center(
                    child: ColorLoader4(
                    dotOneColor: Colors.red,
                    dotTwoColor: Colors.blue,
                    dotThreeColor: Colors.amber,
                    dotType: DotType.circle,
                  ))
                : Column(
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            CategoryTile('Nature'),
                            CategoryTile('Sports'),
                            CategoryTile('Cityscape'),
                            CategoryTile('People'),
                            CategoryTile('Food'),
                            CategoryTile('Vehicles')
                          ])),
                      CarouselSlider(
                        items: [
                          MainStack(data[0]),
                          MainStack(data[1]),
                          MainStack(data[2]),
                          MainStack(data[3]),
                          MainStack(data[4]),
                          MainStack(data[5]),
                          MainStack(data[6]),
                          MainStack(data[7]),
                          MainStack(data[8]),
                          MainStack(data[9]),
                          MainStack(data[10]),
                          MainStack(data[13]),
                          MainStack(data[14]),
                          MainStack(data[15]),
                          MainStack(data[16]),
                          MainStack(data[17]),
                          MainStack(data[18]),
                          MainStack(data[19]),
                          MainStack(data[20]),
                          MainStack(data[21]),
                        ],
                        options: CarouselOptions(
                          height: 160.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          viewportFraction: 0.8,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: size.width * 0.5,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 5),
                        itemBuilder: (ctx, i) {
                          return Pic(data[i + 22]);
                        },
                        itemCount: data.length - 23,
                      )),
                    ],
                  );
          }),
    );
  }
}
