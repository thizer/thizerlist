import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/settings.dart';

import 'widgets/HomeList.dart';

class Layout {

  static final pages = [
    HomePage.tag,
    AboutPage.tag,
    SettingsPage.tag
  ];

  static int currItem = 0;

  static Scaffold getContent(BuildContext context, content) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary(),
        title: Center(
          child: Text('ThizerList'),
        ),
        actions: _getActions(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currItem,
        fixedColor: primary(),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text('Sobre')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Configurações'))
        ],
        onTap: (int i) {
          currItem = i;
          Navigator.of(context).pushNamed(pages[i]);
        },
      ),
      body: content,
    );
  }

  static List<Widget> _getActions(context) {
    List<Widget> items = List<Widget>();

    // Fora da pagina home nao mostra acao alguma
    if (pages[currItem] != HomePage.tag) {
      return items;
    }

    TextEditingController _c = TextEditingController();

    items.add(
      GestureDetector(
        onTap: () {

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext ctx) {

              final input = TextFormField(
                controller: _c,
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
                      
                      HomeList.items.add(
                        ListTile(
                          leading: Icon(Icons.pages),
                          title: Text(_c.text),
                          trailing: Icon(Icons.settings_applications),
                        )
                      );

                      print(_c.text);

                      Navigator.of(ctx).pop();
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

    items.add(Padding(padding: EdgeInsets.only(right: 20)));

    return items;
  }

  static Color primary([double opacity = 1]) => Color.fromRGBO(62, 63, 89, opacity);
  static Color secondary([double opacity = 1]) => Color.fromRGBO(150, 150, 150, opacity);
  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(6, 166, 59, opacity);
  static Color info([double opacity = 1]) => Color.fromRGBO(0, 122, 166, opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);

}
