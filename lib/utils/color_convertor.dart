import 'dart:ui';

Color stringToColor(String colorString) {
  return Color(int.parse(colorString));
}

String colorToString(Color color) =>
    '0x${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';