import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheTextField extends StatelessWidget {
  final TextEditingController inputText;
  final String? label;
  final bool isAutoFocus;

  TheTextField({
    super.key,
    required this.inputText,
    this.label,
    this.isAutoFocus = false, // ✅ default here
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: isAutoFocus, // no '!'
      controller: inputText,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
        labelText: label,
      ),
    );
  }
}
