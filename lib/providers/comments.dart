import 'dart:convert';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Comment {
  final String id;
  final String username;
  final String comment;
  Comment({@required this.id, @required this.username, @required this.comment});
}

class CommentProvider with ChangeNotifier {
  List<Comment> _comment = [];

  List<Comment> get comment {
    return [..._comment];
  }

  var key;
  Future<void> sendComment(Comment comment) async {
    final url =
        'https://wallpaper-app-ec5d5-default-rtdb.firebaseio.com/${comment.id}/comment.json';

    final sentComment = await http.post(Uri.parse(url),
        body: json.encode({
          'id': comment.id,
          'username': comment.username,
          'comment': comment.comment
        }));

    Comment newComment = Comment(
        id: comment.id, username: comment.username, comment: comment.comment);

    _comment.add(newComment);

    key = json.decode(sentComment.body)['name'];

    notifyListeners();
  }

  Stream<List<Comment>> getComments(String id) async* {
    final url =
        'https://wallpaper-app-ec5d5-default-rtdb.firebaseio.com/$id/comment.json';

    final commentJson = await http.get(Uri.parse(url));

    final commentData = json.decode(commentJson.body) as Map<String, dynamic>;
    List<Comment> comments;
    if (commentData != null)
      try {
        commentData.values.forEach((element) {
          comments.add(Comment(
              id: element['id'],
              username: element['username'],
              comment: element['commment']));
          return comments;
        });
      } catch (e) {
        print(e);
      }
    // commentData.forEach((key, element) {}

    notifyListeners();
  }
}
