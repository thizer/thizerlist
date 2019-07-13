import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:thizerlist/application.dart';
import 'package:thizerlist/layout.dart';
import 'items.dart';

import 'package:thizerlist/models/Item.dart';

class ItemEditPage extends StatefulWidget {

  static String tag = 'page-item-edit';
  static Map item;

  @override
  _ItemEditPageState createState() => _ItemEditPageState();
}

class _ItemEditPageState extends State<ItemEditPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cQtd = TextEditingController();
  final MoneyMaskedTextController _cValor =MoneyMaskedTextController(
    thousandSeparator: '.',
    decimalSeparator: ',',
    leftSymbol: 'R\$ '
  );

  @override
  Widget build(BuildContext context) {

    // Instancia model
    ModelItem itemBo = ModelItem();

    _cName.text = ItemEditPage.item['name'];
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
        return null;
      },
    );

    _cQtd.text = ItemEditPage.item['quantidade'].toString();
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
        if (value.isEmpty || int.parse(value) < 1) {
          return 'Informe um número positivo';
        }
        return null;
      },
    );

    _cValor.text = ItemEditPage.item['valor'];
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
        return null;
      },
    );

    Container content = Container(
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Text(
              "Editar: '"+ItemEditPage.item['name'].toString()+"'",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),
            ),
            SizedBox(height: 20),
            inputName,
            SizedBox(height: 20),
            inputQuantidade,
            SizedBox(height: 20),
            inputValor,
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              RaisedButton(
                color: Layout.secondary(),
                child: Text('Cancelar', style:TextStyle(color: Layout.light())),
                padding: EdgeInsets.only(left: 50, right: 50),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                color: Layout.primary(),
                child: Text('Salvar', style:TextStyle(color: Layout.light())),
                padding: EdgeInsets.only(left: 50, right: 50),
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                    // Adiciona no banco de dados
                    itemBo.update(
                      {
                        'fk_lista': ItemsPage.pkList,
                        'name': _cName.text,
                        'quantidade': _cQtd.text,
                        'valor': _cValor.text,
                        'created': DateTime.now().toString()
                      },
                      ItemEditPage.item['pk_item']
                    ).then((saved) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(ItemsPage.tag);
                    });
                  }
                },
              )
            ])
          ]
        ),
      )
    );

    return Layout.getContent(context, content, false);
  }
}
