import 'package:flutter/material.dart';

import 'number_input.dart';

class MarbleItem extends StatefulWidget {
  const MarbleItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarbleItemState();
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

class _MarbleItemState extends State<MarbleItem> {
  // Controlers
  final pricePerMeterController = TextEditingController();
  final metersController = TextEditingController();
  final metersOver80Controller = TextEditingController();
  final sinksController = TextEditingController();
  final edgeController = TextEditingController();
  final wallCoveringController = TextEditingController();
  final wallCoveringOver80Controller = TextEditingController();

  double metersPrice = 0;
  double metersOver80Price = 0;
  double edgePrice = 0;
  double sinksPrice = 0;
  double wallCoveringPrice = 0;
  double wallCoveringOver80Price = 0;
  double totalPrice = 0;

  double parseOrZero(String input) {
    double? result = double.tryParse(input);
    if (result == null) return 0;
    return result;
  }

  void _calculatePriceChanges() {
    // Get inputs
    final double pricePerMeter =
        parseOrZero(pricePerMeterController.value.text);
    final double meters = parseOrZero(metersController.value.text);
    final double metersOver80 = parseOrZero(metersOver80Controller.value.text);
    final double sinks = parseOrZero(sinksController.value.text);
    final double edge = parseOrZero(edgeController.value.text);
    final double wallCovering = parseOrZero(wallCoveringController.value.text);
    final double wallCoveringOver80 =
        parseOrZero(wallCoveringOver80Controller.value.text);

    // Calculate outputs
    final metersRes = pricePerMeter * meters;
    final metersOver80Res = pricePerMeter * metersOver80 * 2;
    final sinksRes = sinks;
    final edgeRes = 100 * edge;
    final wallCoverRes = wallCovering * pricePerMeter;
    final wallCoverOver80Res = wallCoveringOver80 * pricePerMeter * 2;
    final totalRes = metersRes +
        metersOver80Res +
        sinksRes +
        edgeRes +
        wallCoverRes +
        wallCoverOver80Res;

    setState(() {
      metersPrice = metersRes;
      metersOver80Price = metersOver80Res;
      sinksPrice = sinksRes;
      edgePrice = edgeRes;
      wallCoveringPrice = wallCoverRes;
      wallCoveringOver80Price = wallCoverOver80Res;
      totalPrice = totalRes;
    });
  }

  @override
  void dispose() {
    pricePerMeterController.dispose();
    metersController.dispose();
    metersOver80Controller.dispose();
    sinksController.dispose();
    edgeController.dispose();
    wallCoveringController.dispose();
    wallCoveringOver80Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    pricePerMeterController.addListener(_calculatePriceChanges);
    metersController.addListener(_calculatePriceChanges);
    metersOver80Controller.addListener(_calculatePriceChanges);
    sinksController.addListener(_calculatePriceChanges);
    edgeController.addListener(_calculatePriceChanges);
    wallCoveringController.addListener(_calculatePriceChanges);
    wallCoveringOver80Controller.addListener(_calculatePriceChanges);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: "מחיר למטר אורך:",
                  hintText: '₪ למטר אורך',
                  suffix: '₪ למטר אורך',
                  allowDecimal: true,
                  controller: pricePerMeterController),
              Container(),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: "מטרים:",
                  hintText: 'מטרים',
                  suffix: 'מטרים',
                  allowDecimal: true,
                  controller: metersController),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$metersPrice ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: 'מטרים מעל רוחב 80 ס"מ',
                  hintText: 'מטרים',
                  suffix: 'מטרים',
                  allowDecimal: true,
                  controller: metersOver80Controller),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$metersOver80Price ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: "כייורים:",
                  hintText: 'מספר כייורים',
                  allowDecimal: true,
                  controller: sinksController),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$sinksPrice ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: "קנט:",
                  hintText: 'מטרים',
                  suffix: 'מטרים',
                  allowDecimal: true,
                  controller: edgeController),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$edgePrice ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: "חיפוי קיר:",
                  hintText: 'מטרים',
                  suffix: 'מטרים',
                  allowDecimal: true,
                  controller: wallCoveringController),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$wallCoveringPrice ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              NumberInput(
                  label: 'חיפוי קיר מעל רוחב 80 ס"מ:',
                  hintText: 'מטרים',
                  suffix: 'מטרים',
                  allowDecimal: true,
                  controller: wallCoveringOver80Controller),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text('$wallCoveringOver80Price ₪'),
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              const Text('Total Price:'),
              Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text('$totalPrice₪')),
            ],
          ),
        ],
      ),
    );
  }
}
