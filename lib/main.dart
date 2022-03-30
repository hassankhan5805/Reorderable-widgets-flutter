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
  TextEditingController newValue = TextEditingController();
  TextEditingController indexController = TextEditingController();
  TextEditingController deleteIndex = TextEditingController();
  bool flagA = false;
  bool flagB = false;
  final List<int> _firstListItems =
      List<int>.generate(50, (int index) => index);
  final List<int> _secondListItems =
      List<int>.generate(50, (int index) => index);
  late final List<List<int>> _lists = [_firstListItems, _secondListItems];
  func(int oldIndex, int newIndex, List<int> listItems) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final int item = listItems.removeAt(oldIndex);
      listItems.insert(newIndex, item);
    });
  }

  String dropdownvalue = 'List 1';
  String dropdownvalue2 = 'List 1';

  var items = [
    'List 1',
    'List 2',
  ];
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String? err;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 550,
            child: ReorderableListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final List<int> item = _lists.removeAt(oldIndex);
                  _lists.insert(newIndex, item);
                });
              },
              children: <Widget>[
                for (int index = 0; index < _lists.length; index += 1)
                  reOrderList(
                      _lists[index],
                      "$index",
                      index == 1 ? _buildListAItems : _buildListBItems,
                      index == 1 ? _buildDragTargetsA : _buildDragTargetsB,
                      index == 1
                          ? _firstListItems.length
                          : _secondListItems.length)
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Index Nmber",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      int listLength;
                      if (dropdownvalue == "List 1") {
                        listLength = _firstListItems.length;
                      } else {
                        listLength = _secondListItems.length;
                      }
                      if (value!.isEmpty) {
                        return 'This is required field';
                      } else if (double.parse(value.toString()) < 0 ||
                          double.parse(value.toString()) > listLength) {
                        return 'Enter index number between 0 and ${listLength - 1}';
                      } else {
                        return err;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Enter Index Number",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: indexController,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter New Value",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This is required field';
                      } else {
                        return err;
                      }
                    },
                    controller: newValue,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "New Item Value",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 25),
                  child: GestureDetector(
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) {
                        err = null;
                        return;
                      } else {
                        setState(() {
                          if (dropdownvalue == "List 2") {
                            _secondListItems.insert(
                                int.parse(indexController.text),
                                int.parse(newValue.text));

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Item Added to list 2"),
                              backgroundColor: Colors.blue,
                            ));
                          } else if (dropdownvalue.contains("List 1")) {
                            _firstListItems.insert(
                                int.parse(indexController.text),
                                int.parse(newValue.text));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Item added to list 1"),
                              backgroundColor: Colors.blue,
                            ));
                          }
                        });
                      }
                    },
                    child: IntrinsicHeight(
                      child: Container(
                        height: 60.0,
                        width: 250,
                        padding: const EdgeInsets.only(top: 13, bottom: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          'Insert Value',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Index Nmber",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      int listLength;
                      if (dropdownvalue2 == "List 1") {
                        listLength = _firstListItems.length;
                      } else {
                        listLength = _secondListItems.length;
                      }
                      if (value!.isEmpty) {
                        return 'This is required field';
                      }
                      if (double.parse(value.toString()) < 0 ||
                          double.parse(value.toString()) > listLength) {
                        return 'Enter index number between 0 and ${listLength - 1}';
                      } else {
                        return err;
                      }
                    },
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Enter Index Number",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.withOpacity(0.5)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: deleteIndex,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton(
                  value: dropdownvalue2,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue2 = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 25),
                  child: GestureDetector(
                    onTap: () async {
                      if (!_formKey2.currentState!.validate()) {
                        err = null;
                        return;
                      } else {
                        setState(() {
                          if (dropdownvalue2 == "List 2") {
                            _secondListItems
                                .remove(int.parse(deleteIndex.text));

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Item removed to list 2"),
                              backgroundColor: Colors.blue,
                            ));
                          } else if (dropdownvalue2.contains("List 1")) {
                            _firstListItems.remove(int.parse(deleteIndex.text));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Item removed to list 1"),
                              backgroundColor: Colors.blue,
                            ));
                          }
                        });
                      }
                    },
                    child: IntrinsicHeight(
                      child: Container(
                        height: 60.0,
                        width: 250,
                        padding: const EdgeInsets.only(top: 13, bottom: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          'Delete Value',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListBItems(BuildContext context, int index) {
    return Draggable<int>(
//      the value of this draggable is set using data
      data: _secondListItems[index],
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
    return Draggable<int>(
      data: _firstListItems[index],
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
    return DragTarget<int>(
//      builder responsible to build a widget based on whether there is an item being dropped or not
      builder: (context, candidates, rejects) {
        return candidates.length > 0
            ? _buildDropPreview(context, candidates[0].toString())
            : Container(
                width: 5,
                height: 5,
              );
      },
//      condition on to accept the item or not
      onWillAccept: (value) {
        if (_firstListItems.contains(value)) {
          setState(() {
            flagA = true; //print("list a to a ");
          });
        }
        if (_secondListItems.contains(value)) {
          setState(() {
            flagA = false; //print("list b to a ");
          });
        }

        return !_secondListItems.contains(value) ||
            !_firstListItems.contains(value);
      },
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          if (flagA) {
            print("a to a ");
            _firstListItems.insert(index + 1, value);
            _firstListItems.remove(value);
          } else {
            _firstListItems.insert(index + 1, value);
            _secondListItems.remove(value);
          }
        });
      },
    );
  }

//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<int>(
      builder: (context, candidates, rejects) {
        return candidates.length > 0
            ? _buildDropPreview(context, candidates[0].toString())
            : Container(
                width: 5,
                height: 5,
              );
      },
      onWillAccept: (value) {
        if (_firstListItems.contains(value)) {
          setState(() {
            flagB = true; //print("list a to b ");
          });
        }
        if (_secondListItems.contains(value)) {
          setState(() {
            flagB = false; //print("list b to b ");
          });
        }

        return !_secondListItems.contains(value) ||
            !_firstListItems.contains(value);
      },
      onAccept: (value) {
        setState(() {
          if (flagB) {
            print("a to b");
            _secondListItems.insert(index + 1, value);
            _firstListItems.remove(value);
          } else {
            _secondListItems.insert(index + 1, value);
            _secondListItems.remove(value);
          }
        });
      },
    );
  }

  Widget reOrderList(final List<int> listItems, String keys, _buildListBItems,
      _buildDragTargetsB, len) {
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
            width: 500,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 40),
              children: <Widget>[
                ListView.separated(
                  key: Key("$keys"),
                  itemBuilder: _buildListBItems,
                  separatorBuilder: _buildDragTargetsB,
                  itemCount: len,
                )
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
