import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'taskDb';

  static Future<void> intiDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}tasksDb.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print("create a new database");
          db.execute(
              "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title SRTING, note STRING, isCompleted INTEGER, date STRING, startTime STRING, endTime STRING, color INTEGER, reminde INTEGER, repeat STRING)");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    print("delete function called");
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE $_tableName
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
