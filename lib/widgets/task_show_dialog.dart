import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:select_field/select_field.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentations/home/category_cubit.dart';
import 'package:todo_app/presentations/home/task_cubit.dart';
import 'package:todo_app/utils/the_string_casing.dart';
import 'package:todo_app/widgets/the_select_field.dart';
import 'package:todo_app/widgets/the_text_field.dart';

class TaskShowyDialog extends StatefulWidget {
  TaskModel? taskModel;

  TaskShowyDialog({super.key, this.taskModel});

  @override
  State<TaskShowyDialog> createState() => _TaskShowyDialogState();
}

class _TaskShowyDialogState extends State<TaskShowyDialog> {

  List<Option<String>> categoryOptions = [];
  int? _selectedCategory;
  TaskPriority? _selectedPriority;
  TaskRepeat? _taskRepeat;
  final List<Option<String>> priorityOptions =
      TaskPriority.values
          .map((e) => Option(value: e.name, label: e.name.capitalize()))
          .toList();
  final List<Option<String>> repeatOptions =
      TaskRepeat.values
          .map((e) => Option(value: e.name, label: e.name.capitalize()))
          .toList();
    late TextEditingController taskName = TextEditingController();


  @override
  void initState() {
    super.initState();
    final state = context.read<CategoryCubit>().state;
    if (state is CategoryLoaded) {
      final categories = state.categories;
      categoryOptions =
          categories.map((category) {
            return Option<String>(
              value: category.id.toString(),
              label: category.name,
            );
          }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    return AlertDialog(
      backgroundColor: AppColor.blue20,
      title: Text(
        'Add Task',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
      content: Column(
        spacing: 6.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TheTextField(inputText: taskName, label: 'Task'),
          const Text('Choose category'),
          TheSelectField(
            options: categoryOptions,
            onChanged: (value) {
              setState(() {
                _selectedCategory = int.parse(value);
              });
            },
          ),
          const Text('Choose priority'),
          TheSelectField(
            options: priorityOptions,
            onChanged: (value) {
              setState(() {
                _selectedPriority = TaskPriority.values.firstWhere(
                  (e) => e.name == value,
                );
                debugPrint('priority: ${_selectedPriority!.name}');
              });
            },
          ),
          const Text('Choose repeat'),
          TheSelectField(
            options: repeatOptions,
            onChanged: (value) {
              setState(() {
                _taskRepeat = TaskRepeat.values.firstWhere(
                  (e) => e.name == value,
                );
                debugPrint('repeat: $value');
              });
            },
          ),

          Text('Remind later(optional)'),
          DateTimeFormField(
            // decoration: const InputDecoration(
            //   labelText: 'Remind date',
            // ),
            firstDate: DateTime.now().add(const Duration(days: 10)),
            lastDate: DateTime.now().add(const Duration(days: 40)),
            initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
            onChanged: (DateTime? value) {
              selectedDate = value;
            },
          ),

        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: AppColor.gray80)),
        ),
        TextButton(
          onPressed: () {
            final taskModel = TaskModel(
              taskName: taskName.text,
              categoryId: _selectedCategory!,
              priority: _selectedPriority!,
              taskDate: DateTime.now(),
              taskRepeat: _taskRepeat!,
            );
            context.read<TaskCubit>().addTask(taskModel);
            context.read<CategoryCubit>().loadCategories();
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
