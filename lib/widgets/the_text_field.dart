import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheTextField extends StatelessWidget {
  TheTextField({super.key, required this.inputText, this.label});

  TextEditingController inputText = TextEditingController();
  String? label;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
