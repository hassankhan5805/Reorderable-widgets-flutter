import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<int> _firstListItems =
      List<int>.generate(50, (int index) => index);
  final List<int> _secondListItems =
      List<int>.generate(50, (int index) => index);
  // late List<Widget> widgetList = [
  //   reOrderList(_firstListItems, "0"),
  //   reOrderList(_secondListItems, "1"),
  // ];
  late final List<List<int>> _lists = [_firstListItems, _secondListItems];
  final List<String> keys = ["0", "1"];
  func(int oldIndex, int newIndex, List<int> listItems) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final int item = listItems.removeAt(oldIndex);
      listItems.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 550,
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final List<int> item = _lists.removeAt(oldIndex);
                _lists.insert(newIndex, item);
              });
              // ODO: Coding instruction
              //       Do all code in this page
              //       Do not use other plugins
              //       Code need to be fully customizable
              // ODO: Make the parent list also reordered
              // ODO: Make lists item draggable and reordered between the lists (vertical & horizontal)
              // ODO: Add an item to a particular list without rebuilding the other lists
              // ODO: Remove an item to a particular list without rebuilding the other lists
              // ODO: Make it responsive
            },
            children: <Widget>[
              for (int index = 0; index < _lists.length; index += 1)
                reOrderList(_lists[index], "$index")
            ],
          ),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _firstListItems.insert(
                        _firstListItems.length , _firstListItems.length);
                  });
                },
                child: const Text('Add item to list 1')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _secondListItems.insert(
                        _secondListItems.length, _secondListItems.length);
                  });
                },
                child: const Text('Add item to list 2')),
          ],
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _firstListItems.removeAt(_firstListItems.length - 1);
                  });
                },
                child: const Text('Remove item from list 1')),
            TextButton(
                onPressed: () {
                  setState(() {
                    _secondListItems.removeAt(_secondListItems.length - 1);
                  });
                },
                child: const Text('Remove item from list 2')),
          ],
        ),
      ],
    );
  }

  Widget reOrderList(final List<int> listItems, String keys) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return SizedBox(
      key: Key(keys),
      height: 250,
      child: Column(
        children: [
          Container(
            height: 20,
            color: Colors.red,
          ),
          SizedBox(
            height: 200,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 40),
              children: <Widget>[
                for (int index = 0; index < listItems.length; index += 1)
                  SizedBox(
                    width: 150,
                    key: Key('$index'),
                    child: ListTile(
                      tileColor: _secondListItems[index].isOdd
                          ? oddItemColor
                          : evenItemColor,
                      title: Text('Item ${listItems[index]}'),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                func(oldIndex, newIndex, listItems);
              },
            ),
          ),
        ],
      ),
    );
  }
}
