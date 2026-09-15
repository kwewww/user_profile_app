import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isCompact => screenWidth < 380;
}
