import 'package:flutter/foundation.dart';

enum TaskPriority { high, medium, low }
enum TaskType { oneTime, daily, weekday, weekend }

class TaskModel {
  final int id;
  final String taskName;
  final int categoryId;
  final TaskPriority priority;
  final DateTime taskDate;
  final bool isComplete;
  final DateTime? completedAt;
  final DateTime? reminderDate;
  final TaskType taskType;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.categoryId,
    required this.priority,
    required this.taskDate,
    required this.isComplete,
    this.completedAt,
    this.reminderDate,
    required this.taskType,
  });

  /// Converts from JSON map to Task object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      taskName: json['task_name'] as String,
      categoryId: json['category_id'] as int,
      priority: _priorityFromString(json['priority'] as String),
      taskDate: DateTime.parse(json['task_date']),
      isComplete: json['is_complete'] == 1,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at']) : null,
      reminderDate: json['reminder_date'] != null ? DateTime.tryParse(json['reminder_date']) : null,
      taskType: _taskTypeFromString(json['task_type'] as String),
    );
  }

  /// Converts Task object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'category_id': categoryId,
      'priority': priority.name,
      'task_date': taskDate.toIso8601String(),
      'is_complete': isComplete ? 1 : 0,
      'completed_at': completedAt?.toIso8601String(),
      'reminder_date': reminderDate?.toIso8601String(),
      'task_type': taskType.name,
    };
  }

  /// Helper: Convert string to TaskPriority enum
  static TaskPriority _priorityFromString(String value) {
    switch (value.toLowerCase()) {
      case 'high':
        return TaskPriority.high;
      case 'medium':
        return TaskPriority.medium;
      case 'low':
        return TaskPriority.low;
      default:
        throw ArgumentError('Invalid priority value: $value');
    }
  }

  /// Helper: Convert string to TaskType enum
  static TaskType _taskTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'one_time':
        return TaskType.oneTime;
      case 'daily':
        return TaskType.daily;
      case 'weekday':
        return TaskType.weekday;
      case 'weekend':
        return TaskType.weekend;
      default:
        throw ArgumentError('Invalid task type value: $value');
    }
  }
}
