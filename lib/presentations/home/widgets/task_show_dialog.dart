import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:select_field/select_field.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentations/home/category_cubit/category_cubit.dart';
import 'package:todo_app/presentations/home/task_cubit/task_cubit.dart';
import 'package:todo_app/utils/the_string_casing.dart';
import 'package:todo_app/widgets/the_select_field.dart';
import 'package:todo_app/widgets/the_snackbar.dart';
import 'package:todo_app/widgets/the_text_field.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class TaskShowyDialog extends StatefulWidget {
  final TaskModel? taskModel;

  const TaskShowyDialog({super.key, this.taskModel});

  @override
  State<TaskShowyDialog> createState() => _TaskShowyDialogState();
}

class _TaskShowyDialogState extends State<TaskShowyDialog> {
  String? _validateInputs() {
    if (taskName.text.trim().isEmpty) {
      return 'Task name is required.';
    }
    if (_selectedCategory == null) {
      return 'Please select a category.';
    }
    if (_selectedPriority == null) {
      return 'Please select a priority.';
    }
    return null;
  }
  final _formKey = GlobalKey<FormState>();
  String? _errorText;
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
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    final state = context.read<CategoryCubit>().state;
    if (state is CategoryLoaded) {
      getCategoryOptions(state);
    }
    if (widget.taskModel != null) {
      taskName.text = widget.taskModel!.taskName;
      _selectedCategory = widget.taskModel!.categoryId;
      _selectedPriority = widget.taskModel!.priority;
      _taskRepeat = widget.taskModel!.taskRepeat;
    } else {
      //give the priority default value
      _selectedPriority = TaskPriority.medium;
      _taskRepeat = TaskRepeat.none;
    }
    // debugPrint('${widget.taskModel!.categoryId}');
  }

  void getCategoryOptions(CategoryLoaded state) {
    categoryOptions =
        state.categories.map((category) {
          return Option<String>(
            value: category.id.toString(),
            label: category.name,
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate;
    return AlertDialog(
      backgroundColor: AppColor.blue20,
      title: Text(
        widget.taskModel != null ? 'Edit task' : 'Add Task',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 6.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TheTextField(
                isAutoFocus: true,
                inputText: taskName,
                label: 'Task',
              ),
              const Text('Choose category'),
              TheSelectField(
                initialOption:
                    _selectedCategory != null
                        ? categoryOptions.firstWhere(
                          (option) =>
                              option.value == _selectedCategory.toString(),
                          orElse: () => Option(value: '', label: ''),
                        )
                        : null,
                options: categoryOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = int.parse(value);
                  });
                },
              ),
              const Text('Choose priority'),
              TheSelectField(
                initialOption: Option(
                  label: _selectedPriority!.name,
                  value: _selectedPriority!.name,
                ),
                options: priorityOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = TaskPriority.values.firstWhere(
                      (e) => e.name == value,
                    );
                  });
                },
              ),
              const Text('Repeat'),
              TheSelectField(
                initialOption:
                    _taskRepeat != null
                        ? Option(
                          value: _taskRepeat!.name,
                          label: _taskRepeat!.name.capitalize(),
                        )
                        : null,
                options: repeatOptions,
                onChanged: (value) {
                  setState(() {
                    _taskRepeat = TaskRepeat.values.firstWhere(
                      (e) => e.name == value,
                    );
                  });
                },
              ),
              Text('Remind later(optional)'),
              DateTimeFormField(
                firstDate: DateTime.now().add(
                  const Duration(days: 0),
                ), // minimum allow date
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ), //maximun allow date
                initialPickerDateTime: DateTime.now().add(
                  const Duration(days: 0),
                ), //Default selected date when picker opens
                onChanged: (DateTime? value) {
                  selectedDate = value;
                },
              ),
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: AppColor.gray90)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _errorText = null;
            });
            final error = _validateInputs();
            if (error != null) {
              setState(() {
                _errorText = error;
              });
              return;
            }
            final taskModel = TaskModel(
              id: widget.taskModel?.id,
              taskName: taskName.text,
              categoryId: _selectedCategory!,
              priority: _selectedPriority!,
              taskDate: DateTime.now(),
              taskRepeat: _taskRepeat,
            );
            if (widget.taskModel == null) {
              context.read<TaskCubit>().addTask(taskModel);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(TheSnackbar.build(context, 'Added new task.'));
            } else {
              context.read<TaskCubit>().updateTask(taskModel);
            }
            context.read<CategoryCubit>().loadCategories();
            Navigator.pop(context);
          },
          child:
              widget.taskModel == null
                  ? const Text('Save')
                  : const Text(
                    'Update',
                    style: TextStyle(color: AppColor.blue80),
                  ),
        ),
      ],
    );
  }
}
