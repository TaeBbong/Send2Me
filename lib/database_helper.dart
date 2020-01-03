import 'dart:async';
import 'dart:io' as io;

import 'memo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String table = 'Memo';
  final String columnId = 'id';
  final String columnText = 'text';
  final String columnColor = 'color';
  final String columnCategory = 'category';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes_1.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnText TEXT, $columnColor INTEGER, $columnCategory INTEGER)');
  }

  Future<int> saveMemo(Memo memo) async {
    var dbClient = await db;
    var result = await dbClient.insert(table, memo.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> getAllMemos() async {
    var dbClient = await db;
    // var result = await dbClient.query(table,
    //     columns: [columnId, columnText, columnColor, columnCategory]);
    var result = await dbClient.rawQuery('SELECT * FROM $table');

    return result.toList();
  }

  Future<List> getMemosByCategory(int category) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('SELECT * FROM $table WHERE $columnCategory == $category');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<Memo> getMemo(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(table,
        columns: [columnId, columnText, columnColor, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Memo.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteMemo(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(table, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateMemo(Memo memo) async {
    var dbClient = await db;
    return await dbClient.update(table, memo.toMap(),
        where: "$columnId = ?", whereArgs: [memo.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
