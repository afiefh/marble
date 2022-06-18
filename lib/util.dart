import 'dart:math';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

String reverse(String s) {
  return s.split('').reversed.join('');
}

double parseOrZero(String input) {
  double? result = double.tryParse(input);
  if (result == null) return 0;
  return result;
}
