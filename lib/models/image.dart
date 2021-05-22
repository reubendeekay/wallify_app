import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Picture {
  final int id;

  final String imageUrl;

  Picture({@required this.id, @required this.imageUrl});
}

class ImagesProvider with ChangeNotifier {
  List<Picture> _image = [];

  List<Picture> _category = [];

  List<Picture> get image {
    return [..._image];
  }

  List<Picture> get category {
    return [..._category];
  }

  final apiKey = env['API_KEY'];

  Future<void> getImages() async {
    final url =
        "https://pixabay.com/api/?key=$apiKey&q=cool&image_type=photo&per_page=100";

    final pictures = await http.get(Uri.parse(url));
    final picData = json.decode(pictures.body) as Map<String, dynamic>;

    List<Picture> _receivedImages = [];
    picData['hits'].forEach((element) {
      _receivedImages
          .add(Picture(id: element['id'], imageUrl: element['largeImageURL']));
    });

    _image = _receivedImages;
    print(_image[0].imageUrl);
    notifyListeners();
  }

  Future<void> getCategory(String category) async {
    var url =
        "https://pixabay.com/api/?key=$apiKey&q=$category&image_type=photo&per_page=100";

    final result = await http.get(Uri.parse(url));
    final data = json.decode(result.body) as Map<String, dynamic>;
    final List<Picture> _receivedImages = [];

    data['hits'].forEach((element) {
      _receivedImages
          .add(Picture(id: element['id'], imageUrl: element['largeImageURL']));
    });
    _category = _receivedImages;

    notifyListeners();
  }
}
