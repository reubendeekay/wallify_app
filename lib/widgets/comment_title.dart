import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  final String _username;
  final String _comment;

  CommentTile(this._username, this._comment);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Text(
              '$_username : ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 3,
            ),
            Text('$_comment', style: TextStyle(fontSize: 16)),
          ],
        ));
  }
}
