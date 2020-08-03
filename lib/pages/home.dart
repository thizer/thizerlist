import 'package:flutter/material.dart';
import 'package:thizerlist/blocs/home_list_bloc.dart';
import 'package:thizerlist/layout.dart';
import '../widgets/HomeList.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final HomeListBloc listaBloc = HomeListBloc();

  @override
  void dispose() {
    listaBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = StreamBuilder<List<Map>>(
      stream: listaBloc.lists,
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
              return HomeList(
                items: snapshot.data,
                listaBloc: this.listaBloc,
              );
            }
        }
      },
    );

    return Layout.getContent(context, content);
  }
}
