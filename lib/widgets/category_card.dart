import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  int? totalTasks;
  Color? bg;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function()? onTap;
  bool? isSelected;

  CategoryCard({
    super.key,
    required this.categoryName,
    this.totalTasks = 0,
    this.bg = AppColor.blue30,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.all(8.w),
        width: 160.w,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected == true ? Border.all(color: AppColor.darkBlue,) : Border.all(color: Colors.transparent)
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered category name
            Positioned(
              left: 44.w,
              top: 12.w,
              child: Text(
                categoryName,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
            // Popup menu on the top-right
            Positioned(
              top: -2.w,
              right: -6.w,
              child: PopupMenuButton(
                color: AppColor.blue10,
                icon: Icon(Icons.more_vert, size: 20.w),
                elevation: 1,
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: Text(
                          'Edit',
                          style: TextStyle(color: AppColor.yellow50),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppColor.red40),
                        ),
                      ),
                    ],
              ),
            ),
            Positioned(
              left: 66.w,
              top: 48.w,
              child: Text(
                '$totalTasks',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
