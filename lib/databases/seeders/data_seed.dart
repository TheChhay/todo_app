import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/utils/color_convertor.dart';

import 'package:todo_app/services/category_service.dart';
import 'package:todo_app/services/task_service.dart';

/// Seeds initial categories into the database or in-memory list.
Future<List<CategoryModel>> seedCategories() async {
  return [
    CategoryModel(id: 1, name: 'Work', color: colorToString(AppColor.blue40)),
    CategoryModel(id: 2, name: 'Personal', color: colorToString(AppColor.red30)),
    CategoryModel(id: 3, name: 'Shopping', color: colorToString(AppColor.gray30)),
    CategoryModel(id: 4, name: 'Other', color: colorToString(AppColor.green30)),
  ];
}

/// Seeds initial tasks into the database or in-memory list.
Future<List<TaskModel>> seedTasks() async {
  return [
    TaskModel(
      id: 1,
      taskName: 'Finish project report',
      categoryId: 1,
      priority: TaskPriority.high,
      taskDate: DateTime.now(),
      isComplete: false,
    ),
    TaskModel(
      id: 2,
      taskName: 'Buy groceries',
      categoryId: 3,
      priority: TaskPriority.medium,
      taskDate: DateTime.now().add(Duration(days: 1)),
      isComplete: false,
    ),
    TaskModel(
      id: 3,
      taskName: 'Call mom',
      categoryId: 2,
      priority: TaskPriority.low,
      taskDate: DateTime.now().add(Duration(days: 2)),
      isComplete: false,
    ),
  ];
}

/// Runs all seeders and inserts data into the database.
//#run seeder
Future<void> runSeeder() async {
  final categoryService = CategoryService();
  final taskService = TaskService();

  // Seed categories
  final categories = await seedCategories();
  for (final category in categories) {
    await categoryService.insertCategory(category);
  }

  // Seed tasks
  final tasks = await seedTasks();
  for (final task in tasks) {
    await taskService.insertTask(task);
  }
}
