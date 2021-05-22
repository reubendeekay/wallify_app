import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/models/image.dart';

class Fullscreen extends StatelessWidget {
  static const routeName = '/fullscreen';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final id = ModalRoute.of(context).settings.arguments;
    final _imageData = Provider.of<ImagesProvider>(context).image;
    var _image = _imageData.firstWhere((element) => element.id == id);
    void _downloadImage() async {
      try {
        // Saved with this method.
        var imageId = await ImageDownloader.downloadImage(_image.imageUrl);
        if (imageId == null) {
          return;
        }
      } on PlatformException catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: _image.imageUrl,
              fit: BoxFit.cover,
              height: size.height,
            ),
            Positioned(
              bottom: size.height * 0.025,
              left: size.width * 0.2,
              child: GestureDetector(
                onTap: () {
                  _downloadImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  height: 40,
                  width: 250,
                  child: Center(
                    child: Text(
                      'Save to Gallery',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
