import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/loaders/colorloader4.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/widgets/picture.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  var _isClicked = true;

  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImagesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Row(
            children: [
              Center(
                child: AnimatedContainer(
                  padding: EdgeInsets.only(top: 12, left: 12),
                  duration: Duration(seconds: 4),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    onEditingComplete: () {
                      if (searchController.text.isNotEmpty)
                        FocusScope.of(context).unfocus();
                      imageData.getCategory(searchController.text);
                      setState(() {
                        _isClicked = false;
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: '\t\t\tSearch..',
                    ),
                  ),
                  height: 45,
                  width: 250,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (searchController.text.isNotEmpty) {
                      imageData.getCategory(searchController.text);
                      setState(() {
                        _isClicked = false;
                      });
                    }
                  }),
              DropdownButton(items: []),
            ],
          ),
        ],
      ),
      body: _isClicked
          ? ColorLoader5(
              dotType: DotType.circle,
              dotOneColor: Colors.red,
              dotTwoColor: Colors.blue,
              dotThreeColor: Colors.amber,
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
                  itemBuilder: (ctx, i) => Pic(imageData.category[i]),
                  itemCount: imageData.category.length,
                )),
              ],
            ),
    );
  }
}
