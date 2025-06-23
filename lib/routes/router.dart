import 'package:go_router/go_router.dart';
import 'package:todo_app/layouts/default_layout.dart';
import 'package:todo_app/presentations/home/calendar/calender_page.dart';
import 'package:todo_app/presentations/home/home_page.dart';
import 'package:todo_app/presentations/splash/splash_page.dart';
import 'package:todo_app/presentations/statistic/statistic_page.dart';
import 'package:todo_app/routes/router_name.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: RouterName.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return DefaultLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: RouterName.homePage,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/calendar',
          name: RouterName.calendarPage,
          builder: (context, state) => const CalenderPage(),
        ),
        GoRoute(
          path: '/statistic',
          name: RouterName.statisticPage,
          builder: (context, state) => const StatisticPage(),
        ),
      ],
    ),
  ],
);
