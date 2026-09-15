import 'package:flutter/material.dart';

extension WidgetPaddingExtensions on Widget {
  Widget padHorizontal(double value) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);
  }

  Widget padTop(double value) {
    return Padding(padding: EdgeInsets.only(top: value), child: this);
  }
}

extension NumberSpacingExtensions on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}
