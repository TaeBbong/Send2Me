import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_memo/comment_model.dart';

import 'memo_model.dart';
import 'category_model.dart';
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
  final String columnDate = 'date';

  final String table_category = 'Category';
  final String cat_columnId = 'id';
  final String cat_columnText = 'text';

  final String table_comment = 'Comment';
  final String com_columnId = 'id';
  final String com_columnRoot = 'rootid';
  final String com_columnText = 'text';
  final String com_columnDate = 'date';

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
        'CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnText TEXT, $columnColor INTEGER, $columnCategory INTEGER, $columnDate TEXT)');
    await db.execute(
        'CREATE TABLE $table_category($cat_columnId INTEGER PRIMARY KEY, $cat_columnText TEXT)');
    await db.execute(
        'CREATE TABLE $table_comment($com_columnId INTEGER PRIMARY KEY, $com_columnRoot INTEGER, $com_columnText TEXT, $com_columnDate TEXT)');
    await db.execute(
        'INSERT INTO $table_category VALUES (1, "QUICK"), (2, "STUDY"), (3, "TODO"), (4, "IDEA")');
  }

  Future<int> saveMemo(Memo memo) async {
    var dbClient = await db;
    var result = await dbClient.insert(table, memo.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<int> saveComment(Comment comment) async {
    var dbClient = await db;
    var result = await dbClient.insert(table_comment, comment.toMap());
    return result;
  }

  Future<List> getCommentsByRoot(int rootId) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        'SELECT * FROM $table_comment WHERE $com_columnRoot == $rootId');

    return result.toList();
  }

  Future<int> updateComment(Comment comment) async {
    var dbClient = await db;
    return await dbClient.update(table_comment, comment.toMap(),
        where: "$com_columnId = ?", whereArgs: [comment.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future<int> deleteComment(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(table_comment, where: '$com_columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<List> getAllMemos() async {
    var dbClient = await db;
    // var result = await dbClient.query(table,
    //     columns: [columnId, columnText, columnColor, columnCategory]);
    var result = await dbClient.rawQuery('SELECT * FROM $table');

    return result.toList();
  }

  Future<List> getAllCategories() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('SELECT * FROM $table_category');

    return result.toList();
  }

  Future<int> updateCategory(Category category) async {
    var dbClient = await db;
    return await dbClient.update(table_category, category.toMap(),
        where: "$cat_columnId = ?", whereArgs: [category.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
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
        columns: [
          columnId,
          columnText,
          columnColor,
          columnCategory,
          columnDate
        ],
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
