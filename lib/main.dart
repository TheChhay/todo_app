import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/configs/app_cubit_provider.dart';
import 'package:todo_app/configs/custom_theme.dart';
import 'package:todo_app/routes/router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // deleteAppDatabase();
  runApp(const App());
}

Future<void> deleteAppDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'master_db.db'); // your database name
  await deleteDatabase(path);
  print('Database deleted: $path');
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) =>
          MultiBlocProvider(
            providers: appCubitProviders,
            child: MaterialApp.router(
              title: 'To do App',
              theme: CustomTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              darkTheme: CustomTheme.darkTheme,
              routerConfig: appRouter,
            ),
          ),
    );
  }
}
