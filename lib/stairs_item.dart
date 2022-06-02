import 'package:flutter/material.dart';
import 'package:marble/util.dart';

import 'item.dart';
import 'number_input.dart';

class StairsItem extends BaseItem {
  double pricePerMeter;
  double units;
  double length;
  double width;
  bool withRiser;
  bool processingFront;
  bool processingLeft;
  bool processingRight;
  double processingCost;

  StairsItem(
    super.key, {
    this.pricePerMeter = 0,
    this.units = 0,
    this.length = 0,
    this.width = 0,
    this.withRiser = false,
    this.processingFront = false,
    this.processingLeft = false,
    this.processingRight = false,
    this.processingCost = 0,
  });

  riserCost() {
    return withRiser ? 0.15 * length * pricePerMeter : 0;
  }

  double _realWidth() {
    return width + (withRiser ? 0.15 : 0);
  }

  double _area() {
    return _realWidth() * length;
  }

  double _areaPrice() {
    return _area() * pricePerMeter;
  }

  double processingFrontCost() {
    return (processingFront ? length : 0) * processingCost;
  }

  double processingLeftCost() {
    return (processingLeft ? width : 0) * processingCost;
  }

  double processingRightCost() {
    return (processingRight ? width : 0) * processingCost;
  }

  double _processingPrice() {
    return processingFrontCost() + processingLeftCost() + processingRightCost();
  }

  double totalPrice() {
    return (_areaPrice() + _processingPrice()) * units;
  }
  @override
  double price() {
    return totalPrice();
  }

  String processingSides() {
    return [
      if (processingFront) "קדימה",
      if (processingRight) "ימין",
      if (processingLeft) "שמאל"
    ].join(', ');
  }

  @override
  Widget displayWidget(BuildContext context, List<Widget> buttons) {
    return Table(
      children: [
        TableRow(
            children: [const Text("מחיר למטר אורך:"), Text("$pricePerMeter")]),
        TableRow(children: [const Text("יחידות:"), Text("$units")]),
        TableRow(children: [const Text('אורך:'), Text("$length")]),
        TableRow(children: [const Text("רוחב:"), Text("$width")]),
        TableRow(
            children: [const Text("עם רייזר:"), Text(withRiser ? "כן" : "לא")]),
        TableRow(children: [
          const Text("עיבוד:"),
          Row(children: [Text(processingSides())])
        ]),
        TableRow(
            children: [const Text('מחיר עיבוד:'), Text("$processingCost")]),
        TableRow(children: [
          const Text('מחיר:'),
          Text(
            '${totalPrice()}₪',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        TableRow(children: buttons),
      ],
    );
  }
}

class StairsItemWidget extends StatefulWidget {
  const StairsItemWidget(this.initialItem, {Key? key}) : super(key: key);
  final StairsItem initialItem;

  @override
  State<StatefulWidget> createState() => _StairsItemWidgetState();
}

String? numberValidator(String? value) {
  if (value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if (n == null) {
    return '"$value" is not a valid number';
  }
  return null;
}

class _StairsItemWidgetState extends State<StairsItemWidget> {
  // Controlers
  final pricePerMeterController = TextEditingController();
  final unitsController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final processingCostController = TextEditingController();

  late StairsItem item;

  double parseOrZero(String input) {
    double? result = double.tryParse(input);
    if (result == null) return 0;
    return result;
  }

  void _calculatePriceChanges() {
    // Get inputs
    final double pricePerMeter =
        parseOrZero(pricePerMeterController.value.text);
    final double units = parseOrZero(unitsController.value.text);
    final double length = parseOrZero(lengthController.value.text);
    final double width = parseOrZero(widthController.value.text);
    //final double sinks = parseOrZero(sinksController.value.text);
    //final double edge = parseOrZero(edgeController.value.text);
    //final double wallCovering = parseOrZero(wallCoveringController.value.text);
    final double processingCost =
        parseOrZero(processingCostController.value.text);

    setState(() {
      item.pricePerMeter = pricePerMeter;
      item.units = units;
      item.length = length;
      item.width = width;
      item.processingCost = processingCost;
    });
  }

  @override
  void dispose() {
    pricePerMeterController.dispose();
    unitsController.dispose();
    lengthController.dispose();
    widthController.dispose();
    processingCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    String zeroToEmpty(double val) {
      return val == 0 ? '' : val.toString();
    }

    item = widget.initialItem;
    pricePerMeterController.text = zeroToEmpty(item.pricePerMeter);
    unitsController.text = zeroToEmpty(item.units);
    lengthController.text = zeroToEmpty(item.length);
    widthController.text = zeroToEmpty(item.width);
    processingCostController.text = zeroToEmpty(item.processingCost);

    // Start listening to changes.
    pricePerMeterController.addListener(_calculatePriceChanges);
    unitsController.addListener(_calculatePriceChanges);
    lengthController.addListener(_calculatePriceChanges);
    widthController.addListener(_calculatePriceChanges);
    processingCostController.addListener(_calculatePriceChanges);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("מדרגות"),
        ),
        body: Column(
          children: [
            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "מחיר למטר מרובע:",
                        hintText: '₪ למטר מרובע',
                        suffix: '₪ למטר מרובע',
                        allowDecimal: true,
                        controller: pricePerMeterController),
                    Container(),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "יחידות:",
                        hintText: "מס' יחידות",
                        suffix: 'יחידות',
                        allowDecimal: true,
                        controller: unitsController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.units} יחידות'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: 'אורך',
                        hintText: 'מטרים',
                        suffix: 'מטרים',
                        allowDecimal: true,
                        controller: lengthController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.length} m'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "רוחב:",
                        hintText: 'מטרים',
                        suffix: 'מטרים',
                        allowDecimal: true,
                        controller: widthController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.width} m'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('עם רייזר'),
                      value: item.withRiser,
                      onChanged: (bool? value) {
                        setState(() {
                          item.withRiser = value!;
                        });
                        _calculatePriceChanges();
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${roundDouble(item.riserCost(), 2)} ₪'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('עיבוד קדימה'),
                      value: item.processingFront,
                      onChanged: (bool? value) {
                        setState(() {
                          item.processingFront = value!;
                        });
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                          '${roundDouble(item.processingFrontCost(), 2)} ₪'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('עיבוד ימין'),
                      value: item.processingRight,
                      onChanged: (bool? value) {
                        setState(() {
                          item.processingRight = value!;
                        });
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                          '${roundDouble(item.processingRightCost(), 2)} ₪'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('עיבוד שמאל'),
                      value: item.processingLeft,
                      onChanged: (bool? value) {
                        setState(() {
                          item.processingLeft = value!;
                        });
                      },
                      secondary: const Icon(Icons.hourglass_empty),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text(
                          '${roundDouble(item.processingLeftCost(), 2)} ₪'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "מחיר עיבוד:",
                        hintText: '₪ למטר עיבוד',
                        suffix: '₪ למטר עיבוד',
                        allowDecimal: true,
                        controller: processingCostController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.processingCost} ₪ למטר עיבוד'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const Text('מחיר סה"ך:'),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Text('${roundDouble(item.totalPrice(), 2)}₪')),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save',
                  onPressed: () {
                    Navigator.pop(context, item);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Discard',
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
