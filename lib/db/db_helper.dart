import 'package:my_todo_list/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(TaskModel? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(TaskModel task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    await _db!.rawUpdate("""
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
""", [1, id]);
  }
//   static updateWholeTask({required int id,required String title}) async {
//     await _db!.rawUpdate("""
//     UPDATE tasks
//     SET isCompleted = ?, title = ?
//     WHERE id = ?
// """, [0,title, id]);
//   }

  static updateWholeTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
    required int id,
  }) async {
    await _db!.rawUpdate("""
  UPDATE tasks SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, color = ?, isCompleted = ? 
  WHERE id = ?
""", [
      title,
      note,
      date,
      startTime,
      endTime,
      remind,
      repeat,
      color,
      0,
      id,
    ]);
  }
}
