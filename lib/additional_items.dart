import 'package:flutter/material.dart';
import 'package:marble/util.dart';

import 'number_input.dart';

class AdditionalItem {
  AdditionalItem({required this.key, required this.name, required this.value});
  final UniqueKey key;
  String name;
  double value;
}

class AdditionalItemsWidget extends StatefulWidget {
  const AdditionalItemsWidget(this.additionalItemsController, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdditionalItemsWidgetState();

  final ValueNotifier<List<AdditionalItem>> additionalItemsController;
}

class _AdditionalItemsWidgetState extends State<AdditionalItemsWidget> {
  get items => super.widget.additionalItemsController.value;

  TableRow additionalItemToWidget(AdditionalItem item) {
    return TableRow(
      key: item.key,
      children: [
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Delete',
          onPressed: () {
            setState(() {
              super
                  .widget
                  .additionalItemsController
                  .value
                  .removeWhere((element) => element.key == item.key);
            });
          },
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              item.name = value;
            });
          },
          readOnly: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: item.name,
          decoration: const InputDecoration(
            hintText: 'תיאור',
          ),
        ),
        NumberInput(
          value: item.value.toString(),
          onChanged: (value) {
            setState(() {
              item.value = parseOrZero(value);
            });
          },
          hintText: 'מחיר',
          suffix: ' ₪',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
        }, children: [
          TableRow(children: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add',
              onPressed: () {
                var newitem =
                    AdditionalItem(key: UniqueKey(), name: "", value: 0);
                setState(() {
                  super.widget.additionalItemsController.value.add(newitem);
                });
              },
            ),
            TableCell(
                child: Text("פרטים נוספים: "),
                verticalAlignment: TableCellVerticalAlignment.middle),
            Container(),
          ]),
          ...super
              .widget
              .additionalItemsController
              .value
              .map((e) => additionalItemToWidget(e))
              .toList(),
        ]),
      ],
    );
  }
}
