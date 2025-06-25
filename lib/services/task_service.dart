import 'package:todo_app/databases/db_sqlite.dart';
import 'package:todo_app/models/task_model.dart';

class TaskService {
  Future<void> insertTask(TaskModel task) async {
    final db = await DatabaseSqlite.instance.database;
    await db.insert('tasks', task.toJson());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await DatabaseSqlite.instance.database;
    final result = await db.query('tasks');
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> deleteTask(int id) async {
    final db = await DatabaseSqlite.instance.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await DatabaseSqlite.instance.database;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}