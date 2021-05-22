import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/providers/darkmode.dart';

class UserSetting extends StatelessWidget {
  final Icon _icon;
  final String _title;
  UserSetting(this._icon, this._title);
  @override
  Widget build(BuildContext context) {
    var isDark = Provider.of<DarkThemeProvider>(context).darkTheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: isDark ? Colors.white12 : Colors.grey[200],
          borderRadius: BorderRadius.circular(30)),
      width: 350,
      child: ListTile(
        leading: _icon,
        title: Text(_title),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
