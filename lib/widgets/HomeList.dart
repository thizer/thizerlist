import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thizerlist/models/Item.dart';

import '../pages/home.dart';
import '../pages/items.dart';
import '../models/Lista.dart';
import '../layout.dart';

enum ListAction { edit, delete, clone }

class HomeList extends StatefulWidget {

  final List<Map> items;
  final HomeListBloc listaBloc;

  HomeList({ this.items, this.listaBloc }) : super();

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  ModelLista listaBo = ModelLista();
  ModelItem itemBo = ModelItem();
  
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
          leading: Icon(Icons.shopping_cart, size: 42, color: Layout.secondary(0.6)),
          title: Text(item['name']),
          subtitle: Text('('+item['qtdItems'].toString()+' itens) - '+df.format(created)),
          trailing: PopupMenuButton<ListAction>(
            onSelected: (ListAction result) {
              switch(result) {
                case ListAction.edit:
                  showEditDialog(context, item);
                break;
                case ListAction.delete:

                  // First of all we delete all items from this list
                  itemBo.deleteAllFromList(item['pk_lista']).then((int rowsDeleted) {
                    
                    // Then delete the list itself
                    listaBo.delete(item['pk_lista']).then((deleted) {
                      if (deleted) {
                        widget.listaBloc.getList();
                      }
                    });
                  });

                break;
                case ListAction.clone:
                  
                  listaBo.insert({
                    'name': item['name']+' (cópia)',
                    'created': DateTime.now().toString()
                  }).then((int newId) {

                    itemBo.itemsByList(item['pk_lista']).then((List<Map> listItems) async {

                      for (Map listItem in listItems) {
                        await itemBo.insert({
                          'fk_lista': newId,
                          'name': listItem['name'],
                          'quantidade': listItem['quantidade'],
                          'valor': listItem['valor'],
                          'checked': 0,
                          'created': DateTime.now().toString()
                        });
                      }

                      widget.listaBloc.getList();
                    });
                  });

                break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<ListAction>>[
                PopupMenuItem<ListAction>(
                  value: ListAction.edit,
                  child: Row(children: <Widget>[
                    Icon(Icons.edit, color: Layout.secondary()),
                    Text('Editar', style: TextStyle(color: Layout.secondary()))
                  ]),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.delete,
                  child: Row(children: <Widget>[
                    Icon(Icons.delete, color: Layout.secondary()),
                    Text('Excluir', style: TextStyle(color: Layout.secondary()))
                  ]),
                ),
                PopupMenuItem<ListAction>(
                  value: ListAction.clone,
                  child: Row(children: <Widget>[
                    Icon(Icons.content_copy, color: Layout.secondary()),
                    Text('Duplicar', style: TextStyle(color: Layout.secondary()))
                  ]),
                )
              ];
            },
          ),
          onTap: () {

            // Aponta na lista qual esta selecionada
            ItemsPage.pkList = item['pk_lista'];
            ItemsPage.nameList = item['name'];

            // Muda de pagina
            Navigator.of(context).pushNamed(ItemsPage.tag);
          },
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Map item) {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {

        TextEditingController _cEdit = TextEditingController();
        _cEdit.text = item['name'];

        final input = TextFormField(
          controller: _cEdit,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nome',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
            )
          ),
        );

        return AlertDialog(
          title: Text('Editar'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                input
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Layout.dark(0.2),
              child: Text('Cancelar', style: TextStyle(color: Layout.light())),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            RaisedButton(
              color: Layout.primary(),
              child: Text('Salvar', style: TextStyle(color: Layout.light())),
              onPressed: () {
                ModelLista listaBo = ModelLista();

                listaBo.update({
                  'name': _cEdit.text,
                  'created': DateTime.now().toString()
                }, item['pk_lista']).then((saved) {

                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pushReplacementNamed(HomePage.tag);

                });
              },
            )
          ],
        );

      }
    );
  }
}
