import 'AbstractModel.dart';
import 'package:thizerlist/application.dart';
import 'package:sqflite/sqflite.dart';

class Lista extends AbstractModel {

  ///
  /// Singleton
  ///
  
  static Lista _this;

  factory Lista() {
    if (_this == null) {
      _this = Lista.getInstance();
    }
    return _this;
  }

  Lista.getInstance() : super();

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
    return db.rawQuery('SELECT * FROM lista ORDER BY created DESC');
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
