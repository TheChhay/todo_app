import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layouts/nav_cubit.dart';
import 'package:todo_app/presentations/home/category_cubit/category_cubit.dart';
import 'package:todo_app/presentations/home/task_cubit/task_cubit.dart';
import 'package:todo_app/services/category_service.dart';
import 'package:todo_app/services/task_service.dart';


final taskService = TaskService();
final categoryService = CategoryService();

final appCubitProviders = <BlocProvider>[
  BlocProvider<NavCubit>(create: (_) => NavCubit()),
  BlocProvider<CategoryCubit>(create: (_) => CategoryCubit(categoryService)..loadCategories()),
  BlocProvider<TaskCubit>(create: (_) => TaskCubit(taskService)..loadTasks()),
];