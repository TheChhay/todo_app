import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/configs/app_colors.dart';

class ListColor extends StatefulWidget {
  final void Function(Color color)? pickColor;
  Color? selectedColor;
  ListColor({super.key, this.pickColor, this.selectedColor});

  @override
  State<ListColor> createState() => _ListColorState();
}

class _ListColorState extends State<ListColor> {
  final List<Color> colors = [
    AppColor.blue40,
    AppColor.red30,
    AppColor.gray30,
    AppColor.green30,
    AppColor.yellow30,
    AppColor.violet30,
  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selectedColor != null) {
      widget.selectedColor = widget.selectedColor;
    }else{
      widget.selectedColor = AppColor.blue40;

    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: colors.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final color = colors[index];
        final isSelected = color == widget.selectedColor;

        return GestureDetector(
          onTap: () {
            setState(() {
              widget.selectedColor = color;
            });
            widget.pickColor?.call(color);
          },
          child: Container(
            margin: EdgeInsets.all(4.w),
            height: 30.w,
            width: 30.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.grey : Colors.transparent,
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}
