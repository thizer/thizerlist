import 'dart:async';

import 'package:thizerlist/models/Lista.dart';

class HomeListBloc {
  HomeListBloc() {
    getList();
  }

  ModelLista listaBo = ModelLista();

  final _controller = StreamController<List<Map>>.broadcast();

  get lists => _controller.stream;

  dispose() {
    _controller.close();
  }

  getList() async {
    _controller.sink.add(await listaBo.list());
  }
}
