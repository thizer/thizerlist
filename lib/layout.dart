import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/Lista.dart';
import 'pages/about.dart';
import 'pages/home.dart';
import 'pages/settings.dart';

class Layout {
  static BuildContext scaffoldContext;

  static final pages = [
    HomePage.tag,
    AboutPage.tag,
    SettingsPage.tag,
  ];

  static int currItem = 0;

  static SingleChildScrollView getContent(
    BuildContext context,
    content, [
    bool showbottom = true,
  ]) {
    var demoBar = BottomAppBar(
      color: Colors.grey,
      notchMargin: 5.0,
      shape: CircularNotchedRectangle(),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: currItem == 0 ? Layout.primary() : Layout.light(),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(color: currItem == 0 ? Layout.primary() : Layout.light()),
                    ),
                  ],
                ),
                onTap: () {
                  currItem = 0;
                  Navigator.of(context).pushReplacementNamed(pages[0]);
                },
              ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.question_answer,
                      color: currItem == 1 ? Layout.primary() : Layout.light(),
                    ),
                    Text(
                      'Sobre',
                      style: TextStyle(color: currItem == 1 ? Layout.primary() : Layout.light()),
                    ),
                  ],
                ),
                onTap: () {
                  currItem = 1;
                  Navigator.of(context).pushReplacementNamed(pages[1]);
                },
              ),
            ),
          ],
        ),
      ),
    );

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(title: Text('ThizerList')),
          // bottomNavigationBar: showbottom ? bottomNavBar : null,
          bottomNavigationBar: showbottom ? demoBar : null,
          body: new Builder(
            builder: (BuildContext context) {
              // Store the scaffold context to show snackbars
              Layout.scaffoldContext = context;

              return content;
            },
          ),
          floatingActionButton: !showbottom || pages[currItem] != HomePage.tag
              ? null
              : FloatingActionButton(
                  heroTag: 'addlist',
                  child: Icon(Icons.add),
                  elevation: 0.0,
                  onPressed: () {
                    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                    TextEditingController _c = TextEditingController();

                    // Define o locale e a formatacao de data
                    var locale = Localizations.localeOf(context);
                    var df = DateFormat('MMMM', locale.toString());

                    // Pega o mes por extenso
                    var mes = df.format(DateTime.now());
                    mes = mes[0].toUpperCase() + mes.substring(1);

                    // Input inicia com o texto da data de hoje
                    _c.text = "${DateTime.now().day} de $mes";

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext ctx) {
                        final input = Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _c,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Nome',
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Este campo não pode ficar vazio';
                              }
                              return null;
                            },
                          ),
                        );

                        return AlertDialog(
                          title: Text('Nova Lista'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[input],
                            ),
                          ),
                          actions: <Widget>[
                            RaisedButton(
                              color: Layout.dark(0.2),
                              child: Text('Cancelar', style: TextStyle(color: Layout.light())),
                              onPressed: () => Navigator.of(ctx).pop(),
                            ),
                            RaisedButton(
                              color: primary(),
                              child: Text('Adicionar', style: TextStyle(color: Layout.light())),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  ModelLista listaBo = ModelLista();

                                  await listaBo.insert({'name': _c.text, 'created': DateTime.now().toString()});

                                  Navigator.of(ctx).pop();
                                  Navigator.of(ctx).pushReplacementNamed(HomePage.tag);
                                }
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  static Color primary([double opacity = 1]) => Colors.red[700].withOpacity(opacity);
  static Color primaryDark([double opacity = 1]) => Color(0xff9a0007).withOpacity(opacity);
  static Color primaryLight([double opacity = 1]) => Color(0xffff6659).withOpacity(opacity);

  static Color secondary([double opacity = 1]) => Colors.teal[700].withOpacity(opacity);
  static Color secondaryDark([double opacity = 1]) => Color(0xff004c40).withOpacity(opacity);
  static Color secondaryLight([double opacity = 1]) => Color(0xff48a999).withOpacity(opacity);

  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(5, 100, 50, opacity);
  static Color info([double opacity = 1]) => Colors.blue[900].withOpacity(opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);
}
