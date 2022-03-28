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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Column(
      children: [
        SizedBox(
          height: 550,
          child: ReorderableListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            onReorder: (int oldIndex, int newIndex) {
              // TODO: Coding instruction
              //       Do all code in this page
              //       Do not use other plugins
              //       Code need to be fully customizable
              // TODO: Make the parent list also reordered
              // TODO: Make lists item draggable and reordered between the lists (vertical & horizontal)
              // TODO: Add an item to a particular list without rebuilding the other lists
              // TODO: Remove an item to a particular list without rebuilding the other lists
              // TODO: Make it responsive
            },
            children: <Widget>[
              SizedBox(
                key: const Key('0'),
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
                          for (int index = 0;
                              index < _firstListItems.length;
                              index += 1)
                            SizedBox(
                              width: 150,
                              key: Key('$index'),
                              child: ListTile(
                                tileColor: _firstListItems[index].isOdd
                                    ? oddItemColor
                                    : evenItemColor,
                                title: Text('Item ${_firstListItems[index]}'),
                              ),
                            ),
                        ],
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final int item = _firstListItems.removeAt(oldIndex);
                            _firstListItems.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                key: const Key('1'),
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
                          for (int index = 0;
                              index < _secondListItems.length;
                              index += 1)
                            SizedBox(
                              width: 150,
                              key: Key('$index'),
                              child: ListTile(
                                tileColor: _secondListItems[index].isOdd
                                    ? oddItemColor
                                    : evenItemColor,
                                title: Text('Item ${_secondListItems[index]}'),
                              ),
                            ),
                        ],
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final int item =
                                _secondListItems.removeAt(oldIndex);
                            _secondListItems.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {}, child: const Text('Add item to list 1')),
            TextButton(
                onPressed: () {}, child: const Text('Add item to list 2')),
          ],
        ),
        Row(
          children: [
            TextButton(
                onPressed: () {}, child: const Text('Remove item from list 1')),
            TextButton(
                onPressed: () {}, child: const Text('Remove item from list 2')),
          ],
        ),
      ],
    );
  }
}
