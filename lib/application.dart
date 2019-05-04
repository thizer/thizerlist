import 'package:intl/intl.dart';

String dbName = 'thizerlist.db';
int dbVersion = 1;

List<String> dbCreate = [
  // tb lista
  """CREATE TABLE lista (
    pk_lista INTEGER PRIMARY KEY,
    name TEXT,
    created TEXT
  )""",

  // tb Item
  """CREATE TABLE item (
    pk_item INTEGER PRIMARY KEY,
    fk_lista INTEGER,
    name TEXT,
    quantidade INTEGER,
    valor DECIMAL(10,2),
    created TEXT
  )"""
];

double currencyToDouble(String value) {
  value = value.replaceFirst('R\$ ', '');
  value = value.replaceAll(RegExp(r'\.'), '');
  value = value.replaceAll(RegExp(r'\,'), '.');

  return double.tryParse(value) ?? null;
}

double currencyToFloat(String value) {
  return currencyToDouble(value);
}

String doubleToCurrency(double value) {
  NumberFormat nf = NumberFormat.compactCurrency(locale: 'pt_BR', symbol: 'R\$');
  return nf.format(value);
}

