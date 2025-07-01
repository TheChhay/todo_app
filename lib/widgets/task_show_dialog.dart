import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:select_field/select_field.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/widgets/category_select_field.dart';

class TaskShowyDialog extends StatefulWidget {
  int? id;
  TaskShowyDialog({super.key, this.id});

  @override
  State<TaskShowyDialog> createState() => _TaskShowyDialogState();
}

class _TaskShowyDialogState extends State<TaskShowyDialog> {
  @override
  Widget build(BuildContext context) {
    final List<Option<String>> categoryOptions = [
      Option(value: 'work', label: 'Work'),
      Option(value: 'personal', label: 'Personal'),
      Option(value: 'fitness', label: 'Fitness'),
      Option(value: 'study', label: 'Study'),
    ];

    String _selectedCategory = categoryOptions[0].value;

    return AlertDialog(
      backgroundColor: AppColor.blue20,
      title: Text(
        'Add Task',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task Title',
            ),
          ),
          const SizedBox(height: 12),
          CategorySelectField(
            options: categoryOptions,
            onChanged: (value) {
              // NOTE: This won't persist because this is a StatelessWidget.
              // You should convert to StatefulWidget to manage state.
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            // You can use _selectedCategory here if converted to StatefulWidget
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
