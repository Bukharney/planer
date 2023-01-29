import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/data.dart';

class DBHelper {
  DBHelper._init();
  static final DBHelper instance = DBHelper._init();
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init('tasks.db');
    return _db!;
  }

  static Future<int> insertTask(Task? task) async {
    print("insert function called");
    return await _db?.insert(tableTasks, task!.toJson()) ?? 1;
  }

  static Future<int> insertSchedule(Schedule? schedule) async {
    print("insert function called");
    return await _db?.insert(tableSchedule, schedule!.toJson()) ?? 1;
  }

  // static Future<List<Map<String, dynamic>>> query() async {
  //   print("query function called");
  //   return await _db!.query(_tableName);
  // }

  // static delete(Task task) async {
  //   print("delete function called");
  //   return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  // }

  // static update(int id) async {
  //   return await _db!.rawUpdate('''
  //   UPDATE $_tableName
  //   SET isCompleted = ?
  //   WHERE id = ?
  //   ''', [1, id]);
  // }

  static Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Database> _init(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute(
      '''CREATE TABLE $tableTasks (
        ${TaskFields.ID} $idType,
        ${TaskFields.TITLE} $textType,
        ${TaskFields.NOTE} $textType,
        ${TaskFields.DATE} $textType,
        ${TaskFields.START_TIME} $textType,
        ${TaskFields.END_TIME} $textType,
        ${TaskFields.COLOR} $integerType,
        ${TaskFields.REMIND} $integerType,
        ${TaskFields.REPEAT} $textType,
        ${TaskFields.IS_COMPLETED} $integerType
      )''',
    );

    await db.execute(
      '''CREATE TABLE $tableSchedule (
        ${ScheduleFields.ID} $idType,
        ${ScheduleFields.SUBJECT} $textType,
        ${ScheduleFields.DETAIL} $textType,
        ${ScheduleFields.DAY} $textType,
        ${ScheduleFields.START_TIME} $textType,
        ${ScheduleFields.END_TIME} $textType,
        ${ScheduleFields.COLOR} $integerType,
        ${ScheduleFields.REMIND} $integerType
      )''',
    );
  }

  static Future<Task> createTask(Task task) async {
    final db = await instance.database;

    final id = await db.insert(tableTasks, task.toJson());
    return task.copy(id: id);
  }

  static Future<Schedule> createSchedule(Schedule schedule) async {
    final db = await instance.database;

    final id = await db.insert(tableSchedule, schedule.toJson());
    return schedule.copy(id: id);
  }

  static Future readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.ID} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future readSchedule(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSchedule,
      columns: ScheduleFields.values,
      where: '${ScheduleFields.ID} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Schedule.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future readAllTasks() async {
    final db = await instance.database;
    const orderBy = '${TaskFields.START_TIME} ASC';
    final result = await db.query(tableTasks, orderBy: orderBy);

    return result;
  }

  static Future readAllSchedules() async {
    final db = await instance.database;
    const orderBy = '${ScheduleFields.START_TIME} ASC';
    final result = await db.query(tableSchedule, orderBy: orderBy);

    return result;
  }

  static Future updateTask(Task task) async {
    final db = await instance.database;

    await db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.ID} = ?',
      whereArgs: [task.id],
    );
  }

  static Future updateSchedule(Schedule schedule) async {
    final db = await instance.database;

    await db.update(
      tableSchedule,
      schedule.toJson(),
      where: '${ScheduleFields.ID} = ?',
      whereArgs: [schedule.id],
    );
  }

  static Future deleteTask(int id) async {
    final db = await instance.database;

    await db.delete(
      tableTasks,
      where: '${TaskFields.ID} = ?',
      whereArgs: [id],
    );
  }

  static Future deleteSchedule(int id) async {
    final db = await instance.database;

    await db.delete(
      tableSchedule,
      where: '${ScheduleFields.ID} = ?',
      whereArgs: [id],
    );
  }
}
