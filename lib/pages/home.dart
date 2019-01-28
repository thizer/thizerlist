import 'package:flutter/material.dart';
import 'package:thizerlist/layout.dart';

import 'package:thizerlist/models/Lista.dart';
import '../widgets/HomeList.dart';

class HomePage extends StatefulWidget {

  static String tag = 'home-page';

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  Lista listaBo = Lista();

  @override
  Widget build(BuildContext context){

    final content = FutureBuilder(
      future: listaBo.list(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: Text('Carregando...'));
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            } else {
              return HomeList(items: snapshot.data);
            }
        }
      }
    );

    return Layout.getContent(context, content);
  }
}