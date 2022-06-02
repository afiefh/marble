import 'package:flutter/material.dart';

abstract class BaseItem {
  Key key;
  BaseItem(this.key);

  Widget displayWidget(BuildContext context, List<Widget> buttons);
  double price();
}
