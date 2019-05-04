import 'package:flutter/material.dart';
import 'models/Lista.dart';

import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';

class Layout {

  static final pages = [
    HomePage.tag,
    AboutPage.tag,
    SettingsPage.tag
  ];

  static int currItem = 0;

  static Scaffold getContent(BuildContext context, content, [bool showbottom = true]) {

    BottomNavigationBar bottomNavBar = BottomNavigationBar(
      currentIndex: currItem,
      fixedColor: primary(),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
        BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text('Sobre')),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Configurações'))
      ],
      onTap: (int i) {
        currItem = i;
        Navigator.of(context).pushReplacementNamed(pages[i]);
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary(),
        title: Text('ThizerList'),
        actions: showbottom ? _getActions(context) : [],
      ),
      bottomNavigationBar: showbottom ? bottomNavBar : null,
      body: content,
    );
  }

  static List<Widget> _getActions(BuildContext context) {

    List<Widget> items = List<Widget>();
    TextEditingController _c = TextEditingController();

    if (pages[currItem] == HomePage.tag) {
      items.add(
        GestureDetector(
          onTap: () {

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext ctx) {

                final input = TextFormField(
                  controller: _c,
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
                  title: Text('Nova Lista'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        input
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      color: secondary(),
                      child: Text('Cancelar', style: TextStyle(color: Layout.light())),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    RaisedButton(
                      color: primary(),
                      child: Text('Adicionar', style: TextStyle(color: Layout.light())),
                      onPressed: () {
                        
                        ModelLista listaBo = ModelLista();

                        listaBo.insert({
                          'name': _c.text,
                          'created': DateTime.now().toString()
                        }).then((newRowId) {

                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pushReplacementNamed(HomePage.tag);

                        });

                      },
                    )
                  ],
                );
              }
            );
          },
          child: Icon(Icons.add),
        )
      );
    }

    items.add(Padding(padding: EdgeInsets.only(right: 20)));

    return items;
  }

  static Color primary([double opacity = 1]) => Color.fromRGBO(62, 63, 89, opacity);
  static Color secondary([double opacity = 1]) => Color.fromRGBO(150, 150, 150, opacity);
  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(5, 100, 50, opacity);
  static Color info([double opacity = 1]) => Color.fromRGBO(100, 150, 255, opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);

}
