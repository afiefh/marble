import 'package:flutter/material.dart';
import 'package:marble/stairs_item.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map(_itemToListWidget).toList(),
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddKitchenDialog(context);
            },
            tooltip: 'Add Kitchen',
            heroTag: null,
            child: const Icon(Icons.room),
          ),
          FloatingActionButton(
            onPressed: () {
              _showAddStairsDialog(context);
            },
            tooltip: 'Add Stairs',
            heroTag: null,
            child: const Icon(Icons.stairs),
          ),
        ],
      ),
    );
  }
}
