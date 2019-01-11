import 'package:flutter/material.dart';
import 'dart:async';

class HomeList extends StatefulWidget {

  static List<Widget> items = List<Widget>();

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  @override
  Widget build(BuildContext context) {

    HomeList.items.add(ListTile(
      leading: Icon(Icons.pages),
      title: Text('Item 1'),
      trailing: Icon(Icons.settings_applications),
    ));

    Timer.periodic(Duration(seconds: 5), (a) {

      // print(HomeList.items.length);

      setState(() {

      });
    });

    return ListView(
      shrinkWrap: true,
      children: HomeList.items
    );
  }
}