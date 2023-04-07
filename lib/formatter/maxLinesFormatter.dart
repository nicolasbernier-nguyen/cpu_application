import 'package:flutter/services.dart';

class MaxLinesFormatter extends TextInputFormatter {
  final int maxLines;
  final VoidCallback onLinesExceeded;

  MaxLinesFormatter(this.maxLines, this.onLinesExceeded);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newLineCount = '\n'.allMatches(newValue.text).length + 1;

    if (newLineCount > maxLines) {
      if (onLinesExceeded != null) {
        onLinesExceeded();
      }
      return oldValue;
    }
    return newValue;
  }
}
