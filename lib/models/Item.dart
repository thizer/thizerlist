import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:thizerlist/application.dart';

import 'AbstractModel.dart';

enum ItemsListOrderBy { alphaASC, alphaDESC }
enum ItemsListFilterBy { checked, unchecked, all }

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
  Future<List<Map>> itemsByList(
    int fkLista,
    ItemsListOrderBy orderBy,
    ItemsListFilterBy filterBy,
  ) async {
    Database db = await this.getDb();

    String query = '''
      SELECT
        i.*,
        (
          SELECT COUNT(1)
          FROM item i2
          WHERE i2.fk_lista = $fkLista
          LIMIT 1
        ) as qtd_total,
        (
          SELECT COUNT(1)
          FROM item i2
          WHERE i2.fk_lista = $fkLista AND i2.checked = 1
          LIMIT 1
        ) as qtd_checked,
        (
          SELECT COUNT(1)
          FROM item i2
          WHERE i2.fk_lista = $fkLista AND i2.checked = 0
          LIMIT 1
        ) as qtd_unchecked
      FROM item i
      WHERE
        i.fk_lista = $fkLista
        ${filterBy == ItemsListFilterBy.checked ? 'AND i.checked = 1' : ''}
        ${filterBy == ItemsListFilterBy.unchecked ? 'AND i.checked = 0' : ''}
      ORDER BY LOWER(i.name) ${(orderBy == ItemsListOrderBy.alphaASC) ? 'ASC' : 'DESC'}
    ''';

    return db.rawQuery(query);
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
