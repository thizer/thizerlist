import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/ItemsList.dart';
import '../models/Item.dart';

import 'package:thizerlist/layout.dart';

import 'item-add.dart';

class ItemsPage extends StatefulWidget {

  static final tag = 'items-page';

  static int pkList;
  static String nameList;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {

  // Filter from search bar
  String filterText = "";
  
  final ItemsListBloc itemsListBloc =ItemsListBloc();

  @override
  void dispose() {
    itemsListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final content = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(230, 230, 230, 0.5),
            padding: EdgeInsets.only(left: 15, top: 10),
            child: Text('Lista: '+ItemsPage.nameList, style: TextStyle(
              fontSize: 16,
              color: Layout.primary()
            )),
          ),
          Container(
            color: Color.fromRGBO(230, 230, 230, 0.5),
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Pesquisar',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        filterText = text;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Layout.info(),
                    onPressed: () {

                      // Abre tela para criar item de lista
                      Navigator.of(context).pushNamed(ItemAddPage.tag);
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ]
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 249,
            child: StreamBuilder<List<Map>>(
              stream: itemsListBloc.lists,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(child: Text('Carregando...'));
                    break; // Useless after return
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ItemsList(items: snapshot.data, filter: filterText);
                    }
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(100, 150, 255, 0.3),
                  Color.fromRGBO(255, 150, 240, 0.3)
                ]
              ),
            ),
            height: 80,
            child: Row(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(children: <Widget>[Text('Items'), Text('10', textScaleFactor: 1.2)]),
                    Column(children: <Widget>[Text('Carrinho'), Text('2', textScaleFactor: 1.2)]),
                    Column(children: <Widget>[Text('Faltando'), Text('8', textScaleFactor: 1.2)]),
                  ],
                ),
              ),
              Container(
                color: Color.fromRGBO(0, 0, 0, 0.04),
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Sub  : R\$ 5,00', style: TextStyle(
                      fontSize: 18,
                      color: Layout.dark(0.6),
                      fontWeight: FontWeight.bold
                    )),
                    Text('Total: R\$ 15,00', style: TextStyle(
                      fontSize: 18,
                      color: Layout.info(),
                      fontWeight: FontWeight.bold
                    ))
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );

    return Layout.getContent(context, content, false);
  }
}

class ItemsListBloc {

  ItemsListBloc() {
    getList();
  }

  ModelItem itemBo = ModelItem();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await itemBo.itemsByList(ItemsPage.pkList));
  }
}
