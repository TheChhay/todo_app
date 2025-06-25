import 'dart:ui';

import 'package:todo_app/utils/get_hex_color.dart';

class CategoryModel {
  final int id;
  final String name;
  final String color;
  // final String colorHex; // Optional: color code like "#FF5733"

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    // required this.colorHex,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String,
      // colorHex: json['color_hex'] as String,
    );
  }

  Color getColorValue() => getHexToColor(color);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'color_hex': colorHex,
    };
  }
}
