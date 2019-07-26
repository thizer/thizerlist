import 'package:flutter/services.dart';

class QuantityFormatter extends TextInputFormatter {

  final int precision;

  QuantityFormatter({ this.precision }) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    
    String cleanText = newValue.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    double theValue = double.tryParse(cleanText) ?? 0.0;

    if (this.precision != 0) {
      int oldAfterDot = (oldValue.text.replaceAll(new RegExp(r'.+\.'), '')).length;
      int newAfterDot = (newValue.text.replaceAll(new RegExp(r'.+\.'), '')).length;

      if (oldAfterDot < newAfterDot) {
        theValue *= 10;
      } else if (oldAfterDot > newAfterDot) {
        theValue /= 10;
      }
    }

    String resultValue = theValue.toStringAsFixed(this.precision);

    TextEditingValue result = newValue.copyWith(
      text: resultValue,
      selection: newValue.selection.copyWith(
        baseOffset: resultValue.length,
        extentOffset: resultValue.length
      )
    );

    return result;
  }
}
