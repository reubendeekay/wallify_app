import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/loaders/colorloader2.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/providers/comments.dart';

import 'package:wallpaper/screens/fullscreen.dart';
import 'package:wallpaper/widgets/comment_title.dart';
import 'package:wallpaper/widgets/picture.dart';

class WallpaperDetailScreen extends StatefulWidget {
  static const routeName = '/wallpaper-detail';

  @override
  _WallpaperDetailScreenState createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  final _commentController = TextEditingController();
  var _isFav = true;
  var image;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    String username;
    final commentData = Provider.of<CommentProvider>(context);
    Future<void> _comment() async {
      final value = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      username = value['username'];

      commentData.sendComment(Comment(
          id: image.id.toString(),
          username: value['username'],
          comment: _commentController.text));
    }

    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   title: Text('Wallpaper Details'),
        // ),
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 0,
          expandedHeight: size.height * 0.9,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Related Wallpapers",
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
              background: Swiper(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  final id = ModalRoute.of(context).settings.arguments;
                  final imageData = Provider.of<ImagesProvider>(context);
                  Picture catImage() {
                    return imageData.category.firstWhere((element) {
                      return element.id == id;
                    });
                  }

                  image = imageData.image.firstWhere(
                    (element) {
                      return element.id == id;
                    },
                    orElse: () => catImage(),
                  );

                  void _downloadImage() async {
                    try {
                      // Saved with this method.
                      var imageId =
                          await ImageDownloader.downloadImage(image.imageUrl);
                      if (imageId == null) {
                        return;
                      }
                    } on PlatformException catch (e) {
                      print(e);
                    }
                  }

                  return Column(children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.57,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Fullscreen.routeName,
                                      arguments: id);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: CachedNetworkImage(
                                    imageUrl: image.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.phone_android),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          Fullscreen.routeName,
                                          arguments: id);
                                    }),
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.download_sharp),
                                    onPressed: () {
                                      _downloadImage();
                                    }),
                                IconButton(
                                    icon: _isFav
                                        ? Icon(Icons.favorite_border)
                                        : Icon(Icons.favorite,
                                            color: Colors.red),
                                    onPressed: () async {
                                      setState(() async {
                                        _isFav = !_isFav;
                                      });
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 35,
                                  width: 280,
                                  child: TextField(
                                    controller: _commentController,
                                    enableSuggestions: true,
                                    autocorrect: true,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      hintText: '\t\tLeave a comment',
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () async {
                                      if (_commentController.text.isNotEmpty ||
                                          _commentController.text != null)
                                        await _comment();
                                      setState(() {});
                                      _commentController.clear();
                                      FocusScope.of(context).unfocus();
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      height: size.height * 0.2,
                      width: size.width * 0.8,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Text('Comments',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: StreamBuilder(
                                  stream: commentData
                                      .getComments(image.id.toString()),
                                  builder: (ctx, snapshot) {
                                    return ListView.builder(
                                      itemBuilder: (ctx, i) {
                                        if (commentData.comment[i].id !=
                                                image.id.toString() ||
                                            !commentData.comment[i].id.contains(
                                                image.id.toString()) ||
                                            commentData.comment[i].id == null) {
                                          return Center(
                                            child: Text(''),
                                          );
                                        } else {
                                          return CommentTile(
                                              commentData.comment[i].username,
                                              commentData.comment[i].comment);
                                        }
                                      },
                                      itemCount: commentData.comment.length,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
                },
                autoplay: false,
              )),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, i) => Container(
                  height: size.height * 1.58,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: IgnorePointer(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: size.width * 0.3,
                                    mainAxisExtent: size.height * 0.13,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 5),
                            itemBuilder: (ctx, i) {
                              final imageData = Provider.of<ImagesProvider>(
                                      context,
                                      listen: false)
                                  .image;
                              return Pic(imageData[i + 36]);
                            },
                            itemCount: 44,
                          ),
                        ),
                      ),
                    ],
                  )),
              childCount: 1),
        )
      ],
    ));
  }
}
