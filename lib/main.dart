import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/custom_theme.dart';
import 'package:todo_app/layouts/nav_cubit.dart';
import 'package:todo_app/presentations/splash/splash_page.dart';
import 'package:todo_app/routes/router.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (context, child) => BlocProvider(
            create: (_) => NavCubit(),
            child: MaterialApp.router(
              title: 'To do App',
              theme: CustomTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              // home: const SplashPage(),
              darkTheme: CustomTheme.darkTheme,
              routerConfig: appRouter,
            ),
          ),
    );
  }
}
