import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';

class TheSnackbar {
  static SnackBar build(BuildContext ctx, mss) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
    return SnackBar(
      content: Text(mss, style: TextStyle(
        color: isDark ? AppColor.blue100 : AppColor.blue20
      ),),
      backgroundColor: isDark ? AppColor.blue20 : AppColor.blue100,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 10.w, left: 10.w, right: 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}