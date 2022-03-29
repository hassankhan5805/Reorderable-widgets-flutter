import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        home: Drag(),
      );
}

class Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  final List<int> _firstListItems =
      List<int>.generate(50, (int index) => index);
  final List<int> _secondListItems =
      List<int>.generate(50, (int index) => index);
  late final List<List<int>> _lists = [_firstListItems, _secondListItems];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[200],
      body: SafeArea(
        child: Column(
          children: [
//            list view separated will build a widget between 2 list items to act as a separator
            Expanded(
                child: ListView.separated(
                  itemBuilder: _buildListAItems,
                  separatorBuilder: _buildDragTargetsA,
                  itemCount: _firstListItems.length,
                )),
            Expanded(
                child: ListView.separated(
                  itemBuilder: _buildListBItems,
                  separatorBuilder: _buildDragTargetsB,
                  itemCount: _secondListItems.length,
                )),
          ],
        ),
      ),
    );
  }

//  builds the widgets for List B items
  Widget _buildListBItems(BuildContext context, int index) {
    return Draggable<String>(
//      the value of this draggable is set using data
      data: _secondListItems[index].toString(),
//      the widget to show under the users finger being dragged
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _secondListItems[index].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
//      what to display in the child's position when being dragged
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
//      widget in idle state
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _secondListItems[index].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//  builds the widgets for List A items
  Widget _buildListAItems(BuildContext context, int index) {
    return Draggable<String>(
      data: _firstListItems[index].toString(),
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _firstListItems[index].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _firstListItems[index].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//  will return a widget used as an indicator for the drop position
  Widget _buildDropPreview(BuildContext context, String value) {
    return Card(
      color: Colors.lightBlue[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

//  builds DragTargets used as separators between list items/widgets for list A
  Widget _buildDragTargetsA(BuildContext context, int index) {
    return DragTarget<String>(
//      builder responsible to build a widget based on whether there is an item being dropped or not
      builder: (context, candidates, rejects) {
        return candidates.length > 0 ? _buildDropPreview(context, candidates[0]!):
            Container(
              width: 5,
              height: 5,
            );
      },
//      condition on to accept the item or not
      onWillAccept: (value)=>!_firstListItems.contains(value),
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          _firstListItems.insert(index + 1, int.parse(value));
          _secondListItems.remove(value);
        });
      },
    );
  }

//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.length > 0 ? _buildDropPreview(context, candidates[0]!):
        Container(
          width: 5,
          height: 5,
        );
      },
      onWillAccept: (value)=>!_secondListItems.contains(value),
      onAccept: (value) {
        setState(() {
          _secondListItems.insert(index + 1, int.parse(value));
          _firstListItems.remove(value);
        });
      },
    );
  }
}
