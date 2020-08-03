import 'dart:async';

import 'package:thizerlist/models/Item.dart';
import 'package:thizerlist/pages/items.dart';

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
