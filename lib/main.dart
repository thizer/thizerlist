import 'package:flutter/material.dart';

import 'layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';

void main() => runApp(ThizerList());

class ThizerList extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
    HomePage.tag: (context) => HomePage(),
    AboutPage.tag: (context) => AboutPage(),
    SettingsPage.tag: (context) => SettingsPage()
  };

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'ThizerList',
      theme: ThemeData(
        primaryColor: Layout.primary(),
        accentColor: Layout.secondary(),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36, fontStyle: FontStyle.italic, color: Layout.warning()),
          body1: TextStyle(fontSize: 14)
        )
      ),
      home: HomePage(),
      routes: routes
    );
  }
}