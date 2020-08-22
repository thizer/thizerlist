import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'layout.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';
import 'pages/items.dart';
import 'pages/item-add.dart';
import 'pages/item-edit.dart';

void main() => runApp(ThizerList());

class ThizerList extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => HomePage(),
    AboutPage.tag: (context) => AboutPage(),
    SettingsPage.tag: (context) => SettingsPage(),
    ItemsPage.tag: (context) => ItemsPage(),
    ItemAddPage.tag: (context) => ItemAddPage(),
    ItemEditPage.tag: (context) => ItemEditPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThizerList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Layout.primary(),
        accentColor: Layout.secondary(),
        textTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Layout.primary(),
          ),
          bodyText2: TextStyle(fontSize: 14),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
        Locale('en'),
      ],
      home: HomePage(),
      routes: routes,
    );
  }
}
