import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
  }

  static Future<void> insertData(String table, Map<String, Object> value) async {
    final db = await DBHelper.database();

    db.insert(table, value, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();

    final result = await db.query(table);
    print(result);

    return db.query(table);
  }
}
