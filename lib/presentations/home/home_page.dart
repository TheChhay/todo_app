import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentations/home/category_cubit/category_cubit.dart';
import 'package:todo_app/presentations/home/task_cubit/task_cubit.dart';
import 'package:todo_app/presentations/home/widgets/category_and_add_button.dart';
import 'package:todo_app/utils/color_convertor.dart';
import 'package:todo_app/utils/the_string_casing.dart';
import 'package:todo_app/presentations/home/widgets/category_show_dialog.dart';
import 'package:todo_app/presentations/home/widgets/task_show_dialog.dart';

import '../../widgets/category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel>? _listTasks;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Wait until build is done, then fetch categories
    _loadInitialTasks();
  }
  Future<void> _loadInitialTasks() async {
  final state = context.read<CategoryCubit>().state;
  if (state is CategoryLoaded && state.categories.isNotEmpty) {
    final firstCategory = state.categories.first;
    if (firstCategory.id != null) {
      final tasks = await context.read<TaskCubit>().getAllTasksByCategory(firstCategory.id!);
      setState(() {
        _selectedCategoryId = firstCategory.id;
        _listTasks = tasks;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Text(
                "What's up!",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            //title and button create category
            SliverToBoxAdapter(child: CategoryAndAddButton()),

            // Categories
            SliverToBoxAdapter(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    final categories = state.categories;
                    final totalTasks = state.totalTasks;
                    return categories.isEmpty
                        ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Center(
                            child: Text('No Category please create one!'),
                          ),
                        )
                        : SizedBox(
                          height: 120.w,
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final taskCount = totalTasks!.firstWhere(
                                (element) =>
                                    element['category_id'] == category.id,
                                orElse: () => {'count': 0},
                              );

                              return CategoryCard(
                                isSelected: category.id == _selectedCategoryId,
                                bg: stringToColor(category.color!),
                                categoryName: category.name,
                                totalTasks: taskCount['count'],
                                onTap: () async {
                                  final tasks = await context
                                      .read<TaskCubit>()
                                      .getAllTasksByCategory(category.id!);
                                  setState(() {
                                    _selectedCategoryId = category.id;
                                    _listTasks = tasks;
                                  });
                                },
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => CategoryShowDialog(
                                          categoryModel: category,
                                        ),
                                  );
                                },
                                onDelete: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (dialogContext) => AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'Are you sure you want to delete ',
                                                ),
                                                TextSpan(
                                                  text: category.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: ' category?',
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                  dialogContext,
                                                ); // <-- pop only the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<CategoryCubit>()
                                                    .deleteCategory(
                                                      category.id!,
                                                    );
                                                Navigator.pop(
                                                  dialogContext,
                                                ); // <-- also pop only the dialog
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),

            // Tasks section
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
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

            SliverToBoxAdapter(
              child: BlocConsumer<TaskCubit, TaskState>(
                listener: (context, state) {
                  // if(state is TaskLoaded){
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('data'))
                  //   );
                  // }
                },
                // buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    // final tasks = state.tasks;
                    final categoryId = _selectedCategoryId;

                    final filteredTasks =
                        state.tasks
                            .where((task) => task.categoryId == categoryId)
                            .toList();
                    if (filteredTasks.isEmpty) {
                      return const Center(child: Text('No tasks found'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final isDone = task.isComplete ?? false;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 4.0,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                final updatedTask = TaskModel(
                                  id: task.id,
                                  taskName: task.taskName,
                                  categoryId: task.categoryId,
                                  priority: task.priority,
                                  taskDate: task.taskDate,
                                  taskRepeat: task.taskRepeat,
                                  isComplete: !isDone, // ✅ Toggle here
                                  completedAt: !isDone ? DateTime.now() : null,
                                  reminderDate: task.reminderDate,
                                );

                                // Update state via cubit
                                context.read<TaskCubit>().updateTask(
                                  updatedTask,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.blue10,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        isDone
                                            ? AppColor.green40
                                            : AppColor.blue40,
                                    child: Icon(
                                      isDone
                                          ? CupertinoIcons.check_mark
                                          : CupertinoIcons.circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    task.taskName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.blue100,
                                      decoration:
                                          isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    task.priority.name.capitalize(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColor.gray70,
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    color: AppColor.blue10,
                                    icon: Icon(Icons.more_vert, size: 20.w),
                                    elevation: 1,
                                    itemBuilder:
                                        (context) => [
                                          PopupMenuItem(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (_) => TaskShowyDialog(
                                                      taskModel: task,
                                                    ),
                                              );
                                              // debugPrint('task id: ${task}');
                                            },
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: AppColor.yellow50,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              // Delay the dialog to prevent build context issues in PopupMenuItem
                                              Future.delayed(Duration.zero, () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (
                                                        dialogContext,
                                                      ) => AlertDialog(
                                                        title: const Text(
                                                          'Confirm Delete',
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete this task?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () => Navigator.pop(
                                                                  dialogContext,
                                                                ),
                                                            child: const Text(
                                                              'Cancel',
                                                            ),
                                                          ),
                                                          BlocListener<
                                                            TaskCubit,
                                                            TaskState
                                                          >(
                                                            listener: (
                                                              context,
                                                              state,
                                                            ) {
                                                              if (state
                                                                  is TaskError) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                      state
                                                                          .message,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: TextButton(
                                                              onPressed: () {
                                                                context
                                                                    .read<
                                                                      TaskCubit
                                                                    >()
                                                                    .deleteTask(
                                                                      task.id!,
                                                                    );
                                                                context
                                                                    .read<
                                                                      CategoryCubit
                                                                    >()
                                                                    .loadCategories();
                                                                Navigator.pop(
                                                                  dialogContext,
                                                                );
                                                              },
                                                              child: const Text(
                                                                'OK',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              });
                                            },
                                            child: Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: AppColor.red40,
                                              ),
                                            ),
                                          ),
                                        ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Select a category'));
                  }
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
        backgroundColor: AppColor.blue50, // optional styling
        child: Icon(CupertinoIcons.add, size: 28.w),
      ),
    );
  }
}
