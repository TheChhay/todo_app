// layout/default_layout.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/layouts/nav_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/routes/router_name.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('App')),
      body: child,
      bottomNavigationBar: BlocBuilder<NavCubit, NavState>(
        builder: (context, state) {
          return GNav(
            backgroundColor: AppColor.darkBlue,
            color: AppColor.blue10,
            activeColor: AppColor.blue10,
            onTabChange: (index) {
              context.read<NavCubit>().changeTab(index);
              switch (index) {
                case 0:
                  context.goNamed(RouterName.homePage);
                  break;
                case 1:
                  context.goNamed(RouterName.calendarPage);
                case 2:
                  context.goNamed(RouterName.statisticPage);
                  break;
              }
            },
            tabs: [
              GButton(icon: CupertinoIcons.home, text: 'Home'),
              GButton(icon: CupertinoIcons.calendar, text: 'Calendar'),
              GButton(icon: CupertinoIcons.chart_bar_square_fill, text: 'Statistic'),
            ],
            gap: 8.w,
            
          );
        },
      ),
    );
  }
}
