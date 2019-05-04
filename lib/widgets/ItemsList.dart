import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:thizerlist/layout.dart';
import 'package:thizerlist/application.dart';

class ItemsList extends StatefulWidget {

  final List<Map> items;

  const ItemsList({Key key, this.items}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {

  @override
  Widget build(BuildContext context) {

    // Item default
    if (widget.items.length == 0) {
      return ListView(children: <Widget>[ListTile(
        leading: Icon(Icons.check_box_outline_blank, size: 42),
        title: Text('Nenhum item para exibir ainda'),
      )]);
    }

    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int i) {

        Map item = widget.items[i];

        double realVal =currencyToDouble(item['valor']);
        String valTotal = doubleToCurrency(realVal * item['quantidade']);

        return Slidable(
          delegate: SlidableDrawerDelegate(),
          actionExtentRatio: 0.2,
          closeOnScroll: true,
          child: ListTile(
            leading: GestureDetector(
              child: Icon(Icons.check_box_outline_blank, color: Layout.secondary(), size: 42),
              onTap: () {
                print('Marcar como adquirido');
              },
            ),
            title: Text(item['name']),
            subtitle: Text('${item['quantidade']} X ${item['valor']} = $valTotal'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Editar',
              icon: Icons.edit,
              color: Colors.black45,
              onTap: () {
                print('Editar');
              },
            ),
            IconSlideAction(
              caption: 'Deletar',
              icon: Icons.delete,
              color: Colors.red,
              onTap: () {
                print('Deletar');
              },
            )
          ],
        );
      }
    );
  }
}