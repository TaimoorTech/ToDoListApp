import 'package:sqflite/sqflite.dart' as sql;

import '../model_layer/task.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async{
    await database.execute(
      """CREATE TABLE items(
      id Integer,
      title Text,
      dueDate Text,
      finishedTime Text,
      status Text,
      isDone Text
      )
      """
    );
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "todoDB.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future<int> createItem(final Task newTask) async{
    final db = await SQLHelper.db();
    int id = await db.insert(
        "items",
        newTask.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  static Future<List<Task>> getAllItems() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.query("items");
    return result.map(Task.fromMap).toList();
  }

  static Future<List<Map<String, dynamic>>> searchItem(String title) async{
    final db = await SQLHelper.db();
    return db.query("items", where: "title LIKE ?", whereArgs: ['%$title%']);
  }

  static Future<int> updateItem(final Task updatedTask) async {
    final db = await SQLHelper.db();
    final result = await db.update(
        "items", updatedTask.toMap(),
        where: "id = ?", whereArgs: [updatedTask.id]);
    return result;
  }

  static Future<void> deleteItem(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    }
    catch (err){err.toString();}
  }

  static Future<int> updateStatus(int id, String status)async {
    final db = await SQLHelper.db();
    final data = {'id':id, "isDone":status};
    final result = await db.update( "items", data,
        where: "id = ?", whereArgs: [id]);
    return result;
  }

}

