import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class NumberInput extends StatelessWidget {
  const NumberInput(
      {Key? key,
      this.label,
      this.controller,
      this.onChanged,
      this.error,
      this.icon,
      this.allowDecimal = false,
      this.allowNegative = true,
      this.hintText = '',
      this.suffix = '',
      this.value})
      : super(key: key);

  final TextEditingController? controller;
  final String? value;
  final String? label;
  final Function? onChanged;
  final String? error;
  final Widget? icon;
  final bool allowDecimal;
  final bool allowNegative;
  final String? hintText;
  final String? suffix;

  static String? numberValidator(String? value) {
    if (value == null) {
      return null;
    }
    if (value == "") {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" הוא לא מספר חוקי';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      onChanged: onChanged as void Function(String)?,
      readOnly: false,
      keyboardType:
          TextInputType.numberWithOptions(decimal: allowDecimal, signed: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
      ],
      validator: numberValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          label: label != null ? Text(label!) : null,
          errorText: error,
          icon: icon,
          hintText: hintText,
          suffix: (suffix != null) ? Text(suffix!) : null),
    );
  }

  String _getRegexString() =>
      (allowNegative ? r'-?' : '') +
      (allowDecimal ? r'-?[0-9]*[,.]?[0-9]*' : r'-?[0-9]*');
}
