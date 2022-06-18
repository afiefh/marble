import 'package:flutter/material.dart';
import 'package:marble/util.dart';
import 'package:pdf/widgets.dart' as pw;

import 'additional_items.dart';
import 'item.dart';
import 'number_input.dart';

class KitchenItem extends BaseItem {
  double pricePerMeter;
  double meters;
  double metersOver80;
  double edge;
  double sinks;
  double wallCovering;
  double wallCoveringOver80;
  List<AdditionalItem> additionalItems;

  KitchenItem(
    super.key, {
    this.pricePerMeter = 0,
    this.meters = 0,
    this.metersOver80 = 0,
    this.edge = 0,
    this.sinks = 0,
    this.wallCovering = 0,
    this.wallCoveringOver80 = 0,
    required this.additionalItems,
  });

  double metersPrice() {
    return pricePerMeter * meters;
  }

  double metersOver80ResPrice() {
    return pricePerMeter * metersOver80 * 2;
  }

  double sinkPrice() {
    return sinks;
  }

  double edgePrice() {
    return 100 * edge;
  }

  double wallCoverPrice() {
    return wallCovering * pricePerMeter;
  }

  double wallCoverOver80Price() {
    return wallCoveringOver80 * pricePerMeter * 2;
  }

  double additionalItemsPrice() {
    return additionalItems.fold(
        0, (previousValue, element) => previousValue + element.value);
  }

  double totalPrice() {
    return metersPrice() +
        metersOver80ResPrice() +
        sinkPrice() +
        edgePrice() +
        wallCoverPrice() +
        wallCoverOver80Price() +
        additionalItemsPrice();
  }

  @override
  double price() {
    return totalPrice();
  }

  @override
  Widget displayWidget(BuildContext context, List<Widget> buttons) {
    return Table(
      key: key,
      children: [
        TableRow(
            children: [const Text("מחיר למטר אורך:"), Text("$pricePerMeter")]),
        TableRow(children: [const Text("מטרים:"), Text("$meters")]),
        TableRow(children: [
          const Text('מטרים מעל רוחב 80 ס"מ'),
          Text("$metersOver80")
        ]),
        TableRow(children: [const Text("כייורים"), Text("$sinks")]),
        TableRow(children: [const Text("קנט"), Text("$edge")]),
        TableRow(children: [const Text("חיפוי קיר:"), Text("$wallCovering")]),
        TableRow(children: [
          const Text('חיפוי קיר מעל רוחב 80 ס"מ:'),
          Text("$wallCoveringOver80")
        ]),
        ...additionalItems.map(
          (e) => TableRow(children: [Text(e.name), Text(e.value.toString())]),
        ),
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
          pw.Text(reverse("מטבח"),
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
        ]),
        pw.TableRow(children: [
          pw.Text("$pricePerMeter"),
          pw.Text(reverse("מחיר למטר אורך:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$meters"),
          pw.Text(reverse("מטרים:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$metersOver80"),
          pw.Text(reverse('מטרים מעל רוחב 08 ס"מ')),
        ]),
        pw.TableRow(children: [
          pw.Text("$sinks"),
          pw.Text(reverse("כייורים")),
        ]),
        pw.TableRow(children: [
          pw.Text("$edge"),
          pw.Text(reverse("קנט")),
        ]),
        pw.TableRow(children: [
          pw.Text("$wallCovering"),
          pw.Text(reverse("חיפוי קיר:")),
        ]),
        pw.TableRow(children: [
          pw.Text("$wallCoveringOver80"),
          pw.Text(reverse('חיפוי קיר מעל רוחב 08 ס"מ:')),
        ]),
        ...additionalItems.map(
          (e) => pw.TableRow(children: [
            pw.Text(e.value.toString()),
            pw.Text(reverse(e.name))
          ]),
        ),
        pw.TableRow(children: [
          pw.Text(
            '${totalPrice()}₪',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(reverse('מחיר:')),
        ]),
      ],
    );
  }
}

class KitchenItemWidget extends StatefulWidget {
  const KitchenItemWidget(this.initialItem, {Key? key}) : super(key: key);
  final KitchenItem initialItem;

  @override
  State<StatefulWidget> createState() => _KitchenItemWidgetState();
}

class _KitchenItemWidgetState extends State<KitchenItemWidget> {
  // Controlers
  final pricePerMeterController = TextEditingController();
  final metersController = TextEditingController();
  final metersOver80Controller = TextEditingController();
  final sinksController = TextEditingController();
  final edgeController = TextEditingController();
  final wallCoveringController = TextEditingController();
  final wallCoveringOver80Controller = TextEditingController();
  final additionalItemsController = ValueNotifier<List<AdditionalItem>>([]);

  late KitchenItem item;

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

    setState(() {
      item.pricePerMeter = pricePerMeter;
      item.meters = meters;
      item.metersOver80 = metersOver80;
      item.sinks = sinks;
      item.edge = edge;
      item.wallCovering = wallCovering;
      item.wallCoveringOver80 = wallCoveringOver80;
      item.additionalItems = additionalItemsController.value;
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
    metersController.text = zeroToEmpty(item.meters);
    metersOver80Controller.text = zeroToEmpty(item.metersOver80);
    sinksController.text = zeroToEmpty(item.sinks);
    edgeController.text = zeroToEmpty(item.edge);
    wallCoveringController.text = zeroToEmpty(item.wallCovering);
    wallCoveringOver80Controller.text = zeroToEmpty(item.wallCoveringOver80);
    additionalItemsController.value = item.additionalItems;

    // Start listening to changes.
    pricePerMeterController.addListener(_calculatePriceChanges);
    metersController.addListener(_calculatePriceChanges);
    metersOver80Controller.addListener(_calculatePriceChanges);
    sinksController.addListener(_calculatePriceChanges);
    edgeController.addListener(_calculatePriceChanges);
    wallCoveringController.addListener(_calculatePriceChanges);
    wallCoveringOver80Controller.addListener(_calculatePriceChanges);
    additionalItemsController.addListener(_calculatePriceChanges);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // set this property
      child: Scaffold(
        appBar: AppBar(
          title: const Text("מטבח"),
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
                      child: Text('${item.metersPrice()} ₪'),
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
                      child: Text('${item.metersOver80ResPrice()} ₪'),
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
                      child: Text('${item.sinkPrice()} ₪'),
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
                      child: Text('${item.edgePrice()} ₪'),
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
                      child: Text('${item.wallCoverPrice()} ₪'),
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
                      child: Text('${item.wallCoverOver80Price()} ₪'),
                    ),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    const Text('מחיר סה"ך:'),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Text('${item.totalPrice()}₪')),
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
