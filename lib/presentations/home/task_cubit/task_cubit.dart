import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/task_service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskService _taskService;

  TaskCubit(this._taskService) : super(TaskInitial());

  Future<void> loadTasks() async {
    try {
      emit(TaskLoading());
      final tasks = await _taskService.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      debugPrint('Load tasks failed: $e');
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskService.insertTask(task);
      await loadTasks();
      debugPrint('Add task success');
    } catch (e) {
      debugPrint('Add task failed: $e');
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _taskService.deleteTask(id);
      await loadTasks();
      debugPrint('Delete task success');
    } catch (e) {
      debugPrint('Delete task failed: $e');
      emit(TaskError('Failed to delete task'));
    }
  }

  Future<void> updateTask(TaskModel task) async {
  try {
    await _taskService.updateTask(task);
    await loadTasks();
    debugPrint('Update task success');
  } catch (e) {
    debugPrint('Update task failed: $e');
    emit(TaskError('Failed to update task'));
  }
}

  Future<List<TaskModel>> getAllTasksByCategory(int categoryId) async {
    try {
      return await _taskService.getTasksByCategory(categoryId);
    } catch (e) {
      debugPrint('Get tasks by category failed: $e');
      return []; // return empty list on failure
    }
  }

  //update isComplete task
  Future<void> updateTaskIsComplete(int id, bool isComplete)async{
    await _taskService.updateIsComplete(id, isComplete);
    await loadTasks();
  }

}
