import 'package:todo_app/databases/db_sqlite.dart';
import '../../models/category_model.dart';

class CategoryService {
  Future<void> insertCategory(CategoryModel category) async {
    final db = await DatabaseSqlite.instance.database;
    await db.insert('categories', category.toJson());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await DatabaseSqlite.instance.database;
    final result = await db.query('categories');
    return result.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<void> deleteCategory(int id) async {
    final db = await DatabaseSqlite.instance.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateCategory(CategoryModel category) async {
    final db = await DatabaseSqlite.instance.database;
    await db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<List<Map<String, dynamic>>> countTasksGroupedByCategory() async {
    final db = await DatabaseSqlite.instance.database;

    final result = await db.rawQuery('''
    SELECT category_id, COUNT(*) as count
    FROM tasks
    GROUP BY category_id
  ''');

    return result;
  }


}
