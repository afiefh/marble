import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:marble/invoice.dart';
import 'package:marble/stairs_item.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'item.dart';
import 'kitchen_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'מחשבון שיש חלומה',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MyHomePage(title: 'מחשבון שיש חלומה'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BaseItem> items = [];

  Future<void> _showAddKitchenDialog(BuildContext context) async {
    final KitchenItem? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KitchenItemWidget(KitchenItem(UniqueKey()))),
    );

    if (result != null) {
      setState(() {
        items.add(result);
      });
    }
  }

  Future<void> _showAddStairsDialog(BuildContext context) async {
    final StairsItem? result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => StairsItemWidget(StairsItem(UniqueKey()))),
    );

    if (result != null) {
      setState(() {
        items.add(result);
      });
    }
  }

  Widget _itemToListWidget(BaseItem item) {
    final buttons = <Widget>[
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () async {
          final BaseItem? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (item is KitchenItem) {
                return KitchenItemWidget(item);
              } else if (item is StairsItem) {
                return StairsItemWidget(item);
              } else {
                assert(false); // Don't know what to do with this item!
                return StairsItemWidget(StairsItem(UniqueKey()));
              }
            }),
          );

          if (result == null) return;
          setState(() {
            items[items.indexOf(item)] = result;
          });
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Delete',
        onPressed: () {
          setState(() {
            items.removeWhere((element) => element.key == item.key);
          });
        },
      )
    ];
    return item.displayWidget(context, buttons);
  }

  double _priceTotal() {
    return items
        .map((e) => e.price())
        .fold(0, (value, element) => value + element);
  }

  Future<Uint8List> generateInvoice(PdfPageFormat pageFormat) async {
    final font = await PdfGoogleFonts.openSansLight();
    final invoice = Invoice(
        products: items,
        baseColor: PdfColors.teal,
        accentColor: PdfColors.blueGrey900,
        font: font);
    return invoice.buildPdf(pageFormat);
  }

  Future<void> _generatePdf() async {
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat pageFormat) async =>
            await generateInvoice(pageFormat));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              _generatePdf();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'סה"כ:   ${_priceTotal()}₪',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map(_itemToListWidget).toList(),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.stairs),
            label: 'מדרגות',
            onTap: () => _showAddStairsDialog(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.room),
            label: 'מטבח',
            onTap: () => _showAddKitchenDialog(context),
          )
        ],
      ),
    );
  }
}
