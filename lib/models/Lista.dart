import 'dart:async';

import 'AbstractModel.dart';
import 'package:thizerlist/application.dart';
import 'package:sqflite/sqflite.dart';

class ModelLista extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelLista _this;

  factory ModelLista() {
    if (_this == null) {
      _this = ModelLista.getInstance();
    }
    return _this;
  }

  ModelLista.getInstance() : super();

  ///
  /// The Instance
  ///

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery('''
      SELECT
        L.*,
        (
          SELECT COUNT(1)
          FROM item as i
          WHERE i.fk_lista = L.pk_lista
        ) as qtdItems
      FROM lista as L
      ORDER BY L.created DESC
    ''');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('lista', where: 'pk_lista = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('lista', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('lista', values, where: 'pk_lista = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('lista', where: 'pk_lista = ?', whereArgs: [id]);

    return (rows != 0);
  }

}
