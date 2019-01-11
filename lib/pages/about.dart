import 'package:flutter/material.dart';
import 'package:thizerlist/layout.dart';

class AboutPage extends StatelessWidget {

  static String tag = 'about-page';

  @override
  Widget build(BuildContext context){
    return Layout.getContent(context, Center(
      child: Text(
        'Este app foi criado por Thizer Aplicativos',
        style: TextStyle(color: Layout.dark()),
      ),
    ));
  }
}