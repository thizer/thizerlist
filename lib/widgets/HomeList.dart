import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thizerlist/blocs/home_list_bloc.dart';
import 'package:thizerlist/models/Item.dart';

import '../layout.dart';
import '../models/Lista.dart';
import '../pages/home.dart';
import '../pages/items.dart';

import 'dart:async';

enum ListAction { edit, clone }

class HomeList extends StatefulWidget {
  final List<Map> items;
  final HomeListBloc listaBloc;

  HomeList({this.items, this.listaBloc}) : super();

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
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Nenhuma lista cadastrada ainda...'),
          )
        ],
      );
    }

    DateFormat df = DateFormat('dd/MM/yy HH:mm');

    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        Map item = widget.items[index];

        DateTime created = DateTime.tryParse(item['created']);

        return Dismissible(
          key: Key(item['created'].toString()),
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDeleteDialog(context);
            }
            return false;
          },
          onDismissed: (direction) async {
            // First of all we delete all items from this list
            await itemBo.deleteAllFromList(item['pk_lista']);

            // Then delete the list itself
            await listaBo.delete(item['pk_lista']);

            // Update list
            widget.listaBloc.getList();
          },
          child: ListTile(
            leading: Icon(Icons.shopping_cart, size: 42, color: Layout.secondary(0.6)),
            title: Text(item['name']),
            subtitle: Text(
              '(' + item['qtdItems'].toString() + ' itens) - ' + df.format(created),
            ),
            trailing: PopupMenuButton<ListAction>(
              onSelected: (ListAction result) async {
                switch (result) {
                  case ListAction.edit:
                    showEditDialog(context, item);
                    break;
                  case ListAction.clone:

                    // Cria a nova lista
                    int newId = await listaBo.insert(
                      {'name': item['name'] + ' (cópia)', 'created': DateTime.now().toString()},
                    );

                    // Recupera a lista de items dessa lista
                    List<Map> listItems = await itemBo.itemsByList(
                      item['pk_lista'],
                      ItemsListOrderBy.alphaASC,
                      ItemsListFilterBy.all,
                    );

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
          ),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          );

          return AlertDialog(
            title: Text('Editar'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[input],
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

                  listaBo.update({'name': _cEdit.text, 'created': DateTime.now().toString()}, item['pk_lista']).then(
                      (saved) {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Tem certeza?'),
            content: Container(
              child: Text(
                  'Se você remover esta lista, todos os itens dela serão removidos também e esta ação não poderá ser desfeita.'),
            ),
            actions: <Widget>[
              RaisedButton(
                color: Layout.dark(0.2),
                child: Text('Cancelar', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              RaisedButton(
                color: Layout.primary(),
                child: Text('Excluir', style: TextStyle(color: Layout.light())),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          );
        });
  }
}
