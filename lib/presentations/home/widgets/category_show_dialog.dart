import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/presentations/home/category_cubit/category_cubit.dart';
import 'package:todo_app/utils/color_convertor.dart';
import 'package:todo_app/widgets/list_color.dart';
import 'package:todo_app/widgets/the_text_field.dart';

class CategoryShowDialog extends StatefulWidget {
  final CategoryModel? categoryModel;

  const CategoryShowDialog({super.key, this.categoryModel});

  @override
  State<CategoryShowDialog> createState() => _CategoryShowDialogState();
}

class _CategoryShowDialogState extends State<CategoryShowDialog> {
  TextEditingController _category = TextEditingController();
  String _selectedColor = colorToString(AppColor.blue40);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.categoryModel != null) {
      _category.text = widget.categoryModel!.name;
      _selectedColor = widget.categoryModel!.color!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final category = CategoryModel(
              name: _category.text,
              color: _selectedColor,
            );
            if (widget.categoryModel != null) {
              category.id = widget.categoryModel!.id;
              context.read<CategoryCubit>().updateCategory(category);
              // debugPrint('categorys id: ${category.id}');
            } else {
              context.read<CategoryCubit>().addCategory(category);
            }
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
      backgroundColor: AppColor.blue20,
      title: Text(
        widget.categoryModel != null ? 'Edit Category' : 'Add Category',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.w,
        children: [
          TheTextField(inputText: _category, label: 'Category'),
          Text(
            'Choose color:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
          ),
          SizedBox(
            height: 50.w,
            width: double.maxFinite,
            child: ListColor(
              selectedColor: stringToColor(_selectedColor),
              pickColor: (color) {
                _selectedColor = colorToString(color);
              },
            ),
          ),
        ],
      ),
    );
  }
}
