import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marble/util.dart';
import 'package:pdf/widgets.dart' as pw;

import 'additional_items.dart';
import 'item.dart';
import 'number_input.dart';

class StairsItem extends BaseItem {
  double pricePerMeter;
  double units;
  double length;
  double widthRight;
  double widthLeft;
  bool withRiser;
  bool processingFront;
  bool processingLeft;
  bool processingRight;
  double processingCost;
  double tilingMeters;
  double tilingCost;
  double panels;
  List<AdditionalItem> additionalItems;

  StairsItem(
    super.key, {
    this.pricePerMeter = 0,
    this.units = 0,
    this.length = 0,
    this.widthRight = 0,
    this.widthLeft = 0,
    this.withRiser = false,
    this.processingFront = false,
    this.processingLeft = false,
    this.processingRight = false,
    this.processingCost = 0,
    this.tilingMeters = 0,
    this.tilingCost = 0,
    this.panels = 0,
    required this.additionalItems,
  });

  double riserCost() {
    return withRiser ? 0.15 * length * pricePerMeter : 0;
  }

  double _realWidth() {
    return max(widthRight, widthLeft) + (withRiser ? 0.15 : 0);
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
    return (processingLeft ? widthLeft : 0) * processingCost;
  }

  double processingRightCost() {
    return (processingRight ? widthRight : 0) * processingCost;
  }

  double _processingPrice() {
    return processingFrontCost() + processingLeftCost() + processingRightCost();
  }

  double tilingPrice() {
    return tilingMeters * tilingCost;
  }

  double additionalItemsPrice() {
    return additionalItems.fold(
        0, (previousValue, element) => previousValue + element.value);
  }

  double totalPrice() {
    return (_areaPrice() + _processingPrice()) * units +
        tilingPrice() +
        panels +
        additionalItemsPrice();
  }

  @override
  double price() {
    return totalPrice();
  }

  String processingSides() {
    var sides = [
      if (processingFront) "??????????",
      if (processingRight) "????????",
      if (processingLeft) "????????"
    ];
    if (sides.isEmpty) {
      return "?????? ??????????";
    }
    return sides.join(', ');
  }

  String withRiserStr() {
    return withRiser ? "????" : "????";
  }

  @override
  Widget displayWidget(BuildContext context, List<Widget> buttons) {
    return Table(
      key: key,
      children: [
        TableRow(
            children: [const Text("???????? ???????? ????????:"), Text("$pricePerMeter")]),
        TableRow(children: [const Text("????????????:"), Text("$units")]),
        TableRow(children: [const Text('????????:'), Text("$length")]),
        if (widthLeft == widthRight)
          TableRow(children: [const Text("????????:"), Text("$widthLeft")])
        else ...[
          TableRow(children: [const Text("???????? ????????:"), Text("$widthRight")]),
          TableRow(children: [const Text("???????? ????????:"), Text("$widthLeft")])
        ],
        TableRow(children: [const Text("???? ??????????:"), Text(withRiserStr())]),
        TableRow(children: [
          const Text("??????????:"),
          Row(children: [Text(processingSides())])
        ]),
        TableRow(
            children: [const Text('???????? ??????????:'), Text("$processingCost")]),
        TableRow(children: [const Text('?????? ??????????:'), Text("$tilingMeters")]),
        TableRow(
            children: [const Text('???????? ?????????? ????????:'), Text("$tilingMeters")]),
        TableRow(children: [const Text('????????:'), Text("$panels")]),
        ...additionalItems.map(
          (e) => TableRow(children: [Text(e.name), Text(e.value.toString())]),
        ),
        TableRow(children: [
          const Text('????????:'),
          Text(
            '${totalPrice()}???',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        TableRow(children: buttons),
      ],
    );
  }

  @override
  pw.Widget printWidget(pw.Context context, pw.Font font) {
    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(1)
      },
      children: [
        pw.TableRow(children: [
          pw.Container(),
          pw.Text(reverse("????????????"),
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
        ]),
        pw.TableRow(children: [
          pw.Text("$pricePerMeter"),
          pw.Text(reverse("???????? ???????? ????????:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$units"),
          pw.Text(reverse("????????????:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$length"),
          pw.Text(reverse('????????')),
        ]),
        if (widthLeft == widthRight)
          pw.TableRow(children: [
            pw.Text("$widthRight"),
            pw.Text(reverse("????????")),
          ])
        else ...[
          pw.TableRow(children: [
            pw.Text("$widthRight"),
            pw.Text(reverse("???????? ????????")),
          ]),
          pw.TableRow(children: [
            pw.Text("$widthLeft"),
            pw.Text(reverse("???????? ????????")),
          ])
        ],
        pw.TableRow(children: [
          pw.Text(reverse(withRiserStr())),
          pw.Text(reverse("???? ??????????")),
        ]),
        pw.TableRow(children: [
          pw.Text(reverse(processingSides())),
          pw.Text(reverse("??????????:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$tilingMeters"),
          pw.Text(reverse("?????? ??????????:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$tilingCost"),
          pw.Text(reverse("???????? ?????????? ????????:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$panels"),
          pw.Text(reverse("????????:")),
        ]),
        ...additionalItems.map(
          (e) => pw.TableRow(children: [
            pw.Text(e.value.toString()),
            pw.Text(reverse(e.name))
          ]),
        ),
        pw.TableRow(children: [
          pw.Text(
            '${totalPrice()}???',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(reverse('????????:')),
        ]),
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

enum StairShape {
  square,
  trapezoid,
}

class _StairsItemWidgetState extends State<StairsItemWidget> {
  // Controlers
  final pricePerMeterController = TextEditingController();
  final unitsController = TextEditingController();
  final lengthController = TextEditingController();
  final widthRightController = TextEditingController();
  final widthLeftController = TextEditingController();
  final processingCostController = TextEditingController();
  final tilingMetersController = TextEditingController();
  final tilingCostController = TextEditingController();
  final panelsController = TextEditingController();
  final additionalItemsController = ValueNotifier<List<AdditionalItem>>([]);

  late StairsItem item;

  void _calculatePriceChanges() {
    // Get inputs
    final double pricePerMeter =
        parseOrZero(pricePerMeterController.value.text);
    final double units = parseOrZero(unitsController.value.text);
    final double length = parseOrZero(lengthController.value.text);
    final double widthRight = parseOrZero(widthRightController.value.text);
    final double widthLeft = _stairShape == StairShape.square
        ? widthRight
        : parseOrZero(widthLeftController.value.text);
    final double processingCost =
        parseOrZero(processingCostController.value.text);
    final double tilingMeters = parseOrZero(tilingMetersController.value.text);
    final double tilingCost = parseOrZero(tilingCostController.value.text);
    final double panels = parseOrZero(panelsController.value.text);

    setState(() {
      item.pricePerMeter = pricePerMeter;
      item.units = units;
      item.length = length;
      item.widthRight = widthRight;
      item.widthLeft = widthLeft;
      item.processingCost = processingCost;
      item.tilingMeters = tilingMeters;
      item.tilingCost = tilingCost;
      item.panels = panels;
      item.additionalItems = additionalItemsController.value;
    });
  }

  @override
  void dispose() {
    pricePerMeterController.dispose();
    unitsController.dispose();
    lengthController.dispose();
    widthRightController.dispose();
    widthLeftController.dispose();
    processingCostController.dispose();
    tilingMetersController.dispose();
    tilingCostController.dispose();
    panelsController.dispose();
    additionalItemsController.dispose();
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
    widthRightController.text = zeroToEmpty(item.widthRight);
    widthLeftController.text = zeroToEmpty(item.widthLeft);
    processingCostController.text = zeroToEmpty(item.processingCost);
    tilingMetersController.text = zeroToEmpty(item.tilingMeters);
    tilingCostController.text = zeroToEmpty(item.tilingCost);
    panelsController.text = zeroToEmpty(item.panels);
    additionalItemsController.value = item.additionalItems;
    _stairShape = item.widthLeft == item.widthRight
        ? StairShape.square
        : StairShape.trapezoid;

    // Start listening to changes.
    pricePerMeterController.addListener(_calculatePriceChanges);
    unitsController.addListener(_calculatePriceChanges);
    lengthController.addListener(_calculatePriceChanges);
    widthLeftController.addListener(_calculatePriceChanges);
    widthRightController.addListener(_calculatePriceChanges);
    processingCostController.addListener(_calculatePriceChanges);
    tilingMetersController.addListener(_calculatePriceChanges);
    tilingCostController.addListener(_calculatePriceChanges);
    panelsController.addListener(_calculatePriceChanges);
    additionalItemsController.addListener(_calculatePriceChanges);
  }

  final List<bool> _toggleButtonSelection = [true, false];
  StairShape get _stairShape {
    return StairShape.values[_toggleButtonSelection.indexOf(true)];
  }

  set _stairShape(StairShape shape) {
    _toggleButtonSelection.setAll(0, [false, false]);
    _toggleButtonSelection[shape.index] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("????????????"),
          actions: [
            ToggleButtons(
              isSelected: _toggleButtonSelection,
              onPressed: (int index) {
                setState(() {
                  _toggleButtonSelection.setAll(0, [false, false]);
                  _toggleButtonSelection[index] = true;
                });
              },
              color: Colors.white24,
              selectedColor: Colors.white,
              children: const [
                Icon(Icons.square),
                Icon(Icons.architecture),
              ],
            ),
          ],
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
                        label: "???????? ???????? ??????????:",
                        hintText: '??? ???????? ??????????',
                        suffix: '??? ???????? ??????????',
                        allowDecimal: true,
                        controller: pricePerMeterController),
                    Container(),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "????????????:",
                        hintText: "????' ????????????",
                        suffix: '????????????',
                        allowDecimal: true,
                        controller: unitsController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.units} ????????????'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: '????????',
                        hintText: '??????????',
                        suffix: '??????????',
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
                        label: _stairShape == StairShape.square
                            ? "????????:"
                            : "???????? ????????",
                        hintText: '??????????',
                        suffix: '??????????',
                        allowDecimal: true,
                        controller: widthRightController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.widthRight} m'),
                    ),
                  ],
                ),
                if (_stairShape == StairShape.trapezoid)
                  TableRow(
                    children: <Widget>[
                      NumberInput(
                          label: "???????? ????????",
                          hintText: '??????????',
                          suffix: '??????????',
                          allowDecimal: true,
                          controller: widthLeftController),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Text('${item.widthLeft} m'),
                      ),
                    ],
                  ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('???? ??????????'),
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
                      child: Text('${roundDouble(item.riserCost(), 2)} ???'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('?????????? ??????????'),
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
                          '${roundDouble(item.processingFrontCost(), 2)} ???'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('?????????? ????????'),
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
                          '${roundDouble(item.processingRightCost(), 2)} ???'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    CheckboxListTile(
                      title: const Text('?????????? ????????'),
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
                          '${roundDouble(item.processingLeftCost(), 2)} ???'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "???????? ??????????:",
                        hintText: '??? ???????? ??????????',
                        suffix: '??? ???????? ??????????',
                        allowDecimal: true,
                        controller: processingCostController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.processingCost} ??? ???????? ??????????'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "?????? ??????????:",
                        hintText: '?????? ??????????',
                        suffix: '?????? ??????????',
                        allowDecimal: true,
                        controller: tilingMetersController),
                    Container(),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "???????? ??????????:",
                        hintText: '??? ???????? ??????????',
                        suffix: '??? ???????? ??????????',
                        allowDecimal: true,
                        controller: tilingCostController),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Text('${item.tilingPrice()} ???'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    NumberInput(
                        label: "????????:",
                        hintText: '???',
                        suffix: '???',
                        allowDecimal: true,
                        controller: panelsController),
                    Container(),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const Text('???????? ????"??:'),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Text('${roundDouble(item.totalPrice(), 2)}???')),
                  ],
                ),
              ],
            ),
            AdditionalItemsWidget(additionalItemsController),
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
