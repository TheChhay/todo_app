import 'package:todo_app/databases/db_sqlite.dart';
import 'package:todo_app/models/category_model.dart';
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

  //get all tasks group by category
  Future<List<Map<String, dynamic>>> getAllTaskGroupByCategory() async {
    final db = await DatabaseSqlite.instance.database;

    final resultCategories = await db.query('categories');
    final categories =
        resultCategories.map((json) => CategoryModel.fromJson(json)).toList();
    List<Map<String, dynamic>> result = [];
    for (var category in categories) {
      final tasks = await db.query(
        'tasks',
        where: 'category_id = ?',
        whereArgs: [category.id],
      );

      result.add({'category': category, 'tasks': tasks});
    }

    return result;
  }

  Future<List<TaskModel>> getTasksByCategory(int categoryId) async {
    final db = await DatabaseSqlite.instance.database;
    final result = await db.query(
      'tasks',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

   //update task isComplete task
  Future<void> updateIsComplete(int id, bool isComplete) async {
    final db = await DatabaseSqlite.instance.database;
    await db.update(
      'tasks',
      {'isComplete': isComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
