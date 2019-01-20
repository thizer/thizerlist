import 'package:flutter/material.dart';

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
          SizedBox(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Pesquisar'
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 250,
            child: ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemsList[index];
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 30,
            child: RaisedButton(
              color: Layout.primary(),
              onPressed: () {
                setState(() {
                  _addNewOne();
                });
              },
              child: Text('+ Novo Item', style: TextStyle(color: Layout.light())),
            ),
          ),
          Container(
            color: Colors.deepOrange,
            height: 80,
            child: Row(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Total de items: 1'),
                    Text('Já adiquirido: 0'),
                  ],
                ),
              ),
              Container(
                color: Colors.indigo,
                width: MediaQuery.of(context).size.width/2,
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Total: R\$ 15,00', style: TextStyle(fontSize: 20)),
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
    itemsList.add(ListTile(
      leading: GestureDetector(
        child: Icon(Icons.adjust, color: Colors.green),
        onTap: () {
          print('Marcar como adquirido');
        },
      ),
      title: Text('Nome do item'),
      subtitle: Text('4 X R\$ 1,50 = R\$ 6,00'),
      trailing: GestureDetector(
        child: Icon(Icons.delete),
        onTap: () {
          print('Deletar');
        },
      ),
      onLongPress: () {
        print('Editar produto');
      },
    ));
  }
}