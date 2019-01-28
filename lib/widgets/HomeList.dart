import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/home.dart';
import '../models/Lista.dart';

enum ListAction { edit, delete }

class HomeList extends StatefulWidget {

  final List<Map> items;

  HomeList({this.items}) : super();

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  List<Widget> values = List<Widget>();

  Lista listaBo = Lista();
  
  @override
  Widget build(BuildContext context) {

    // Item default
    if (widget.items.length == 0) {
      return ListView(
        children: <Widget>[ListTile(
          leading: Icon(Icons.pages),
          title: Text('Nenhuma lista cadastrada ainda...'),
        )],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm');

    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {

        Map item = widget.items[index];

        DateTime created = DateTime.tryParse(item['created']);

        return ListTile(
          leading: Icon(Icons.pages),
          title: Text(item['name']),
          subtitle: Text(df.format(created)),
          trailing: PopupMenuButton<ListAction>(
            onSelected: (ListAction result) {
              switch(result) {
                case ListAction.edit:
                  
                break;
                case ListAction.delete:
                  listaBo.delete(item['pk_lista']).then((deleted) {
                    if (deleted) {
                      Navigator.of(context).pushReplacementNamed(HomePage.tag);
                    }
                  });
                break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ListAction>>[
                PopupMenuItem<ListAction>(
                  value: ListAction.edit,
                  child: Row(children: <Widget>[
                    Icon(Icons.edit),
                    Text('Editar')
                  ]),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.delete,
                  child: Row(children: <Widget>[
                    Icon(Icons.delete),
                    Text('Excluir')
                  ]),
                )
              ];
            },
          ),
        );
      },
    );
  }
}