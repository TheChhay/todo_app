import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:select_field/select_field.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/presentations/home/category_cubit.dart';
import 'package:todo_app/presentations/home/task_cubit.dart';
import 'package:todo_app/utils/color_convertor.dart';
import 'package:todo_app/widgets/category_show_dialog.dart';
import 'package:todo_app/widgets/task_show_dialog.dart';
import 'package:todo_app/widgets/category_select_field.dart';
import 'package:todo_app/widgets/list_color.dart';
import 'package:todo_app/widgets/the_text_field.dart';

import '../../widgets/card_total_task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text("What's up!", style: TextStyle(fontSize: 24.sp)),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      color: AppColor.gray80,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CategoryShowDialog(),
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.add,
                      size: 20.sp,
                      color: AppColor.gray90,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            SliverToBoxAdapter(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    final categories = state.categories;
                    final totalTasks = state.totalTasks;
                    return SizedBox(
                      height: 120.w,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final _totalTasks = totalTasks!.firstWhere(
                            (element) => element['category_id'] == category.id,
                            orElse: () => {'count': 0},
                          );
                          debugPrint('category: ${category.id} ${_totalTasks}');
                          return CardTotalTask(
                            bg: stringToColor(category.color!),
                            categoryName: category.name,
                            totalTasks: _totalTasks['count'],
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (context) => CategoryShowDialog(
                                  categoryModel: category,
                                ),
                              );
                            },
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColor.blue10,
                                  title: Align(child: Icon(CupertinoIcons.clear_circled, size: 48.sp, color: AppColor.red40,),alignment: Alignment.center,),
                                  content: Text.rich(
                                    TextSpan(
                                      text: 'Are you sure you want to delete ',
                                      style: TextStyle(color: AppColor.blue100), // base style
                                      children: [
                                        TextSpan(
                                          text: '${category.name}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' category?',
                                        ),
                                      ],
                                    ),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                      },
                                      child: Text('Cancel', style: TextStyle(color: AppColor.gray90)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<CategoryCubit>().deleteCategory(category.id!);
                                        Navigator.pop(context); // Close dialog after deleting
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },

                            // totalTasks: taskCubit.getTaskCountByCategory(category.name),
                          );
                        },
                      ),
                    ); // <-- closing this parenthesis was missing
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),

            // Vertical space before list
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),

            // Task list title
            SliverToBoxAdapter(
              child: Text(
                'Your Tasks',
                style: TextStyle(
                  color: AppColor.gray80,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            // Vertical scrollable list of tasks
            SliverToBoxAdapter(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    final tasks = state.tasks;
                    if (tasks.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          "No tasks found",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task =
                            tasks[index]; // Get the specific task for this item
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ListTile(title: Text(task.taskName)),
                        );
                      },
                    );
                  }
                  // While loading or other states
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: SizedBox(
                        height: 24.w,
                        width: 24.w,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => TaskShowyDialog());
        },
        shape: CircleBorder(),
        child: Icon(CupertinoIcons.add, size: 28.w),
      ),
    );
  }
}
