enum TaskPriority { high, medium, low }

enum TaskRepeat {
  none,
  daily,
  weekday,
  weekend,
}
class TaskModel {
  final int? id;
  final String taskName;
  final int categoryId;
  final TaskPriority priority;
  final DateTime taskDate; // task create at
  final bool? isComplete;
  final DateTime? completedAt;
  final DateTime? reminderDate;
  final DateTime? dateTimeRepeat;
  final TaskRepeat? taskRepeat;

  TaskModel({
    this.id,
    required this.taskName,
    required this.categoryId,
    required this.priority,
    required this.taskDate,
    this.isComplete = false,
    this.completedAt,
    this.reminderDate,
    this.dateTimeRepeat,
    this.taskRepeat,
  });

  /// Converts from JSON map to Task object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int?,
      taskName: json['task_name'] as String,
      categoryId: json['category_id'] as int,
      priority: _priorityFromString(json['priority'] as String),
      taskDate: DateTime.parse(json['task_date']),
      isComplete: json['is_complete'] == 1,
      completedAt:
          json['completed_at'] != null
              ? DateTime.tryParse(json['completed_at'])
              : null,
      reminderDate:
          json['reminder_date'] != null
              ? DateTime.tryParse(json['reminder_date'])
              : null,
      dateTimeRepeat:
          json['datetime_repeat'] != null
              ? DateTime.tryParse(json['datetime_repeat'])
              : null,
      taskRepeat:
          json['task_repeat'] != null
              ? _taskTypeFromString(json['task_repeat'] as String)
              : null,
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
      'is_complete': (isComplete ?? false) ? 1 : 0,
      'completed_at': completedAt?.toIso8601String(),
      'reminder_date': reminderDate?.toIso8601String(),
      'datetime_repeat': dateTimeRepeat?.toIso8601String(),
      'task_repeat': taskRepeat?.name,
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

  static TaskRepeat? _taskTypeFromString(String value) {
    try {
      return TaskRepeat.values.firstWhere((e) => e.name == value);
    } catch (_) {
      throw ArgumentError('Invalid task type value: $value');
    }
  }
}
