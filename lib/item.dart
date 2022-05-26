import 'package:flutter/material.dart';

abstract class BaseItem {
  Key key;
  BaseItem(this.key);

  displayWidget(BuildContext context, List<Widget> buttons);
}
