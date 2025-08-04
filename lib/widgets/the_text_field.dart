import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheTextField extends StatelessWidget {
  TextEditingController inputText = TextEditingController();
  String? label;
  bool? isAutoFocus = false;
  TheTextField({super.key, required this.inputText, this.label, this.isAutoFocus});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: isAutoFocus!,
      controller: inputText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r)
        ),
        labelText: label,
      ),
    );
  }
}
