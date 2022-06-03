import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class BaseItem {
  Key key;
  BaseItem(this.key);

  Widget displayWidget(BuildContext context, List<Widget> buttons);
  pw.Widget printWidget(pw.Context context, pw.Font font);
  double price();
}
