import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/configs/app_cubit_provider.dart';
import 'package:todo_app/configs/custom_theme.dart';
import 'package:todo_app/databases/seeders/data_seed.dart';
import 'package:todo_app/routes/router.dart';
import 'package:todo_app/services/category_service.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:intl/intl_standalone.dart';
import 'package:todo_app/services/noti_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
Future<void> maybeRunSeeder() async {
  final categoryService = CategoryService();
  final taskService = TaskService();
  final categories = await categoryService.getAllCategories();
  final tasks = await taskService.getAllTasks();
  if (categories.isEmpty && tasks.isEmpty) {
    await runSeeder();
    debugPrint('Database seeded.');
  } else {
    debugPrint('Database already has data, skipping seeder.');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // deleteAppDatabase();
  await maybeRunSeeder();
  await MobileAds.instance.initialize();
  await findSystemLocale();
  tz.initializeTimeZones();
  await NotiService().initNotification();
  runApp(const App());
}

Future<void> deleteAppDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'master_db.db'); // your database name
  await deleteDatabase(path);
  debugPrint('Database deleted: $path');
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) => MultiBlocProvider(
            providers: appCubitProviders,
            child: MaterialApp.router(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [Locale('en')],
              title: 'To do App',
              theme: CustomTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              darkTheme: CustomTheme.darkTheme,
              routerConfig: appRouter,
              // locale: Locale(_languageCode),
            ),
          ),
    );
  }
}
