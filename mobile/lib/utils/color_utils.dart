// Shared color utilities

import 'package:flutter/material.dart';

/// Parse a hex color string to a Color object
Color parseHexColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  } catch (e) {
    return Colors.blue;
  }
}
