import 'dart:ui';

Color getHexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // add alpha if missing
  return Color(int.parse('0x$hex'));
}