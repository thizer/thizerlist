import 'dart:async';

import 'AbstractModel.dart';
import 'package:thizerlist/application.dart';
import 'package:sqflite/sqflite.dart';

class ModelItem extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static ModelItem _this;

  factory ModelItem() {
    if (_this == null) {
      _this = ModelItem.getInstance();
    }
    return _this;
  }

  ModelItem.getInstance() : super();

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
    return db.rawQuery('SELECT * FROM item ORDER BY created DESC');
  }

  /// Retorna todos os items da lista
  /// 
  /// [fkLista] ID da lista
  Future<List<Map>> itemsByList(int fkLista) async {
    Database db = await this.getDb();
    return db.rawQuery('SELECT * FROM item WHERE fk_lista = $fkLista ORDER BY name ASC, created DESC');
  }

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query('item', where: 'pk_item = ?', whereArgs: [where], limit: 1);

    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  @override
  Future<int> insert(Map<String, dynamic> values) async {
    Database db = await this.getDb();
    int newId = await db.insert('item', values);

    return newId;
  }

  @override
  Future<bool> update(Map<String, dynamic> values, where) async {

    Database db = await this.getDb();
    int rows = await db.update('item', values, where: 'pk_item = ?', whereArgs: [where]);

    return (rows != 0);
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete('item', where: 'pk_item = ?', whereArgs: [id]);

    return (rows != 0);
  }

  /// Delete all items from a list
  /// @return int Number of rows deleted
  Future<int> deleteAllFromList(dynamic id) async {
    Database db = await this.getDb();
    return await db.delete('item', where: 'fk_lista = ?', whereArgs: [id]);
  }

}
