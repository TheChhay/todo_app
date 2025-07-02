import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/task_service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService _taskService;

  TaskCubit(this._taskService) : super(TaskInitial());

  Future<void> loadTasks() async {
    final tasks = await _taskService.getAllTasks();
    emit(TaskLoaded(tasks));
  }

  Future<void> addTask(TaskModel task) async {
    await _taskService.insertTask(task);
    await loadTasks();
    debugPrint('add task success');
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(task);
    await loadTasks();
  }
  //get all tasks by category
  Future<List<TaskModel>> getAllTasksByCategory(int categoryId) async {
    final result = await _taskService.getTasksByCategory(categoryId);
    return result;
  }

  //update isComplete task
  Future<void> updateTaskIsComplete(int id, bool isComplete)async{
    await _taskService.updateIsComplete(id, isComplete);
    await loadTasks();
  }

}
