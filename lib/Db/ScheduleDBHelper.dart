import 'package:sqflite/sqflite.dart';
import '../models/data.dart';

class ScheduleDBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'schedleDb';

  static Future<void> intiDb() async {
    if (_db != null) {
      return;
    }
    try {
      String path = '${await getDatabasesPath()}schedleDb.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (db, version) {
          print("create a new database");
          db.execute(
              "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, subject SRTING, detail STRING, day STRING, startTime STRING, endTime STRING, color INTEGER, reminde INTEGER)");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Schedule? schedule) async {
    print("insert function called");
    return await _db?.insert(_tableName, schedule!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tableName);
  }

  static delete(Schedule schedule) async {
    print("delete function called");
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }
}
