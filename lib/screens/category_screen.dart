import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/loaders/colorloader2.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/widgets/picture.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/category-screen';

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          title,
        ),
      ),
      body: FutureBuilder(
          future: Provider.of<ImagesProvider>(context, listen: false)
              .getCategory(title),
          builder: (ctx, snapshot) {
            final data = Provider.of<ImagesProvider>(context, listen: false);
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: ColorLoader4(
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.green,
                      dotThreeColor: Colors.amber,
                      dotType: DotType.circle,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                          child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 5),
                        itemBuilder: (ctx, i) => Pic(data.category[i]),
                        itemCount: data.category.length,
                      )),
                    ],
                  );
          }),
    );
  }
}
