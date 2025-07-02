import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/widgets/category_show_dialog.dart';

class CategoryAndAddButton extends StatelessWidget {
  const CategoryAndAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Category',
          style: TextStyle(color: AppColor.gray80, fontWeight: FontWeight.w500),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CategoryShowDialog(),
            );
          },
          icon: Icon(CupertinoIcons.add, size: 20.sp, color: AppColor.gray90),
        ),
      ],
    );
  }
}
