import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/presentations/home/task_cubit.dart';

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
              child: Text(
                'Category',
                style: TextStyle(
                  color: AppColor.gray80,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),

            // Horizontal scroll
            SliverToBoxAdapter(
              child: SizedBox(
                height: 90.w,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CardTotalTask(),
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemCount: 5,
                ),
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
                        final task = tasks[index]; // Get the specific task for this item
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ListTile(
                            title: Text(task.taskName),
                          ),
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
          showDialog(context: context, builder: _showAddTaskDialog);
        },
        shape: CircleBorder(),
        child: Icon(CupertinoIcons.add, size: 28.w),
      ),
    );
  }
}

Widget _showAddTaskDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: AppColor.blue20,
    title: Text('Add Task'),
    content: TextField(
      decoration: InputDecoration(hintText: 'Enter task name!'),
    ),
  );
}
