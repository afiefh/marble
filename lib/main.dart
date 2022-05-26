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
      title: 'Shaiesh Halumi - Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl, // set this property
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  List<BaseItem> items = [];

  Future<void> _showAddKitchenDialog(BuildContext context) async {
    final KitchenItem? result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
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
            // Create the SelectionScreen in the next step.
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
