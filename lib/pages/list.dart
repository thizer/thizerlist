import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:thizerlist/layout.dart';

class ListPage extends StatefulWidget {

  static final tag = 'list-page';

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  List<Widget> itemsList = List<Widget>();

  @override
  void initState() {
    
    _addNewOne();

    super.initState();
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
            child: Text('Nome da lista', style: TextStyle(
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Pesquisar',
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Layout.info(),
                    onPressed: () {
                      setState(() {
                        _addNewOne();
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ]
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 249,
            child: ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemsList[index];
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

  void _addNewOne() {

    ListTile tile = ListTile(
      leading: GestureDetector(
        child: Icon(Icons.adjust, color: Colors.green),
        onTap: () {
          print('Marcar como adquirido');
        },
      ),
      title: Text('Nome do item'),
      subtitle: Text('4 X R\$ 1,50 = R\$ 6,00'),
      trailing: Icon(Icons.arrow_forward_ios),
    );

    itemsList.add(Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.2,
      closeOnScroll: true,
      child: tile,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          icon: Icons.edit,
          color: Colors.black45,
          onTap: () { print('Editar'); },
        ),
        IconSlideAction(
          caption: 'Deletar',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () { print('Deletar'); },
        )
      ],
    ));
  }
}