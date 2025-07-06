import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:select_field/select_field.dart';
import 'package:todo_app/configs/app_colors.dart';

class TheSelectField extends StatelessWidget {
  final List<Option<String>> options;
  final void Function(String)? onChanged;
  final Option<String>? initialOption;
  const TheSelectField({
    super.key,
    required this.options,
    this.onChanged,
    this.initialOption
  });

  @override
  Widget build(BuildContext context) {
    return SelectField<String>(
      initialOption: initialOption,
      menuPosition: MenuPosition.below,
      menuDecoration: MenuDecoration(
        alignment: MenuAlignment.center,height: 160.w,
        separatorBuilder: (context, index) => Container(
          height: 1,
          width: double.infinity,
          color: AppColor.gray70,
        ),
        backgroundDecoration: BoxDecoration(
          color: AppColor.blue20,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 1),
              color: Colors.brown[300]!,
              blurRadius: 3,
            ),
          ],
        ),
      ),
      options: options,
      optionBuilder: (context, option, isSelected, onOptionSelected) {
        return _buildOptionItem(
          context: context,
          option: option,
          isSelected: isSelected,
          onOptionSelected: () {
            onOptionSelected(option);            // Select in UI
            onChanged?.call(option.value);       // Notify parent
          },
        );
      },
    );
  }
}


Widget _buildOptionItem({
  required BuildContext context,
  required Option<String> option,
  required bool isSelected,
  required VoidCallback onOptionSelected,
}) {
  return GestureDetector(
    onTap: onOptionSelected,
    child: isSelected
        ? Container(
      height: 60,
      color: AppColor.blue40,
      child: Center(
        child: Text(
          option.label,
          style: const TextStyle(color: AppColor.blue100),
        ),
      ),
    )
        : SizedBox(
      height: 60,
      child: Center(
        child: Text(
          option.label,
          style: TextStyle(color: AppColor.blue100),
        ),
      ),
    ),
  );
}

