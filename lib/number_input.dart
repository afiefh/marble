import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class NumberInput extends StatelessWidget {
  const NumberInput(
      {Key? key,
      required this.label,
      this.controller,
      this.value,
      this.onChanged,
      this.error,
      this.icon,
      this.allowDecimal = false,
      this.hintText = '',
      this.suffix = ''})
      : super(key: key);

  final TextEditingController? controller;
  final String? value;
  final String label;
  final Function? onChanged;
  final String? error;
  final Widget? icon;
  final bool allowDecimal;
  final String? hintText;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      onChanged: onChanged as void Function(String)?,
      readOnly: false,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.replaceAll('.', ','),
          ),
        ),
      ],
      decoration: InputDecoration(
          label: Text(label),
          errorText: error,
          icon: icon,
          hintText: hintText,
          suffix: (suffix != null) ? Text(suffix!) : null),
    );
  }

  String _getRegexString() =>
      allowDecimal ? r'[0-9]+[,.]{0,1}[0-9]*' : r'[0-9]';
}
