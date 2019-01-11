import 'package:flutter/material.dart';
import 'package:thizerlist/layout.dart';

import '../widgets/HomeList.dart';

class HomePage extends StatelessWidget {

  static String tag = 'home-page';

  @override
  Widget build(BuildContext context){

    final content = HomeList();

    return Layout.getContent(context, content);
  }
}