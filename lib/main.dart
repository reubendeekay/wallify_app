import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/models/image.dart';
import 'package:wallpaper/providers/comments.dart';
import 'package:wallpaper/providers/darkmode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:wallpaper/screens/category_screen.dart';
import 'package:wallpaper/screens/dayswallpaper.dart';
import 'package:wallpaper/screens/developer_screen.dart';
import 'package:wallpaper/screens/fullscreen.dart';
import 'package:wallpaper/screens/login_screen.dart';
import 'package:wallpaper/screens/search_screen.dart';
import 'package:wallpaper/screens/tabscreen.dart';
import 'package:wallpaper/screens/testapiscreen.dart';
import 'package:wallpaper/screens/user_screen.dart';
import 'package:wallpaper/screens/wallpaper_details_screen.dart';
import 'package:wallpaper/screens/wallpaper_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  var auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => themeChangeProvider,
          ),
          ChangeNotifierProvider.value(value: ImagesProvider()),
          ChangeNotifierProvider.value(value: CommentProvider()),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            //home: TestScreen(),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) =>
                  snapshot.hasData ? TabScreen() : LoginScreen(),
            ),
            routes: {
              WallpaperDetailScreen.routeName: (ctx) => WallpaperDetailScreen(),
              CategoryScreen.routeName: (ctx) => CategoryScreen(),
              Fullscreen.routeName: (ctx) => Fullscreen(),
              SearchScreen.routeName: (ctx) => SearchScreen(),
              DaysWallpaper.routeName: (ctx) => DaysWallpaper(),
              WallpaperListScreen.routeName: (ctx) => WallpaperListScreen(),
              HomeView.routeName: (ctx) => HomeView(),
              UserScreen.routeName: (ctx) => UserScreen(),
              TabScreen.routeName: (ctx) => TabScreen(),
            },
          );
        }));
  }
}
