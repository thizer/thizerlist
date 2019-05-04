import 'package:flutter/material.dart';
import '../widgets/ItemsList.dart';

import 'dart:async';
import 'package:thizerlist/application.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../models/Item.dart';

import 'package:thizerlist/layout.dart';

class ItemsPage extends StatefulWidget {

  static final tag = 'items-page';

  static int pkList;

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cQtd = TextEditingController();
  final MoneyMaskedTextController _cValor =MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
  );

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
                      setState(() {
                        _addNewOne(context);
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

  void _addNewOne(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {

        final inputName = TextFormField(
          controller: _cName,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nome do item',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Obrigatório';
            }
          },
        );

        _cQtd.text = '1';
        final inputQuantidade = TextFormField(
          controller: _cQtd,
          autofocus: false,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Quantidade',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
          validator: (value) {
            if (int.parse(value) < 1) {
              return 'Informe um número positivo';
            }
          },
        );

        final inputValor = TextFormField(
          controller: _cValor,
          autofocus: false,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Valor R\$',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
          validator: (value) {
            
            if (currencyToDouble(value) < 0.0) {
              return 'Obrigatório';
            }

          },
        );

        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Adicionar Item'),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                inputName,
                SizedBox(height: 15),
                inputQuantidade,
                SizedBox(height: 15),
                inputValor
              ]),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Layout.secondary(),
                child: Text('Cancelar', style:TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              RaisedButton(
                color: Layout.primary(),
                child: Text('Salvar', style:TextStyle(color: Layout.light())),
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                    // Instancia model
                    ModelItem itemBo = ModelItem();

                    // Adiciona no banco de dados
                    itemBo.insert({
                      'fk_lista': ItemsPage.pkList,
                      'name': _cName.text,
                      'quantidade': _cQtd.text,
                      'valor': _cValor.text,
                      'created': DateTime.now().toString()
                    }).then((saved) {
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pushReplacementNamed(ItemsPage.tag);
                    });
                  }
                },
              )
            ],
          ),
        );
      }
    );
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
