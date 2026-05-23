import 'package:flutter/material.dart';

extension EmptyPadding on num {
  SizedBox get hh => SizedBox(
        height: toDouble(),
      );
  SizedBox get ww => SizedBox(
        width: toDouble(),
      );
}

extension ContextExtensions on BuildContext {

  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}

extension RemoveSpaces on String {
  String removeSpaces() {
    return replaceAll(' ', '');
  }
}

logs(String message, {bool showPrintInRelease = false}) {
  debugPrint(message);

  if (showPrintInRelease) {
    // ignore: avoid_print
    logs(message);
  }
}