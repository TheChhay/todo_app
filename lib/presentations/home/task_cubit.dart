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
  }

  Future<void> deleteTask(int id) async {
    await _taskService.deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _taskService.updateTask(task);
    await loadTasks();
  }

}
