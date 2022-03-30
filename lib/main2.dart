import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Drag(),
      );
}

class Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  List listA = ["A", "B", "C", "D", "E"];
  List listB = ["F", "G", "H", "I"];
  bool flagA = false;
  bool flagB = false;
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
              itemCount: listA.length,
            )),
            Expanded(
                child: ListView.separated(
              itemBuilder: _buildListBItems,
              separatorBuilder: _buildDragTargetsB,
              itemCount: listB.length,
            )),
            // forms(listA, listB)
          ],
        ),
      ),
    );
  }

//  builds the widgets for List B items
  Widget _buildListBItems(BuildContext context, int index) {
    return Draggable<String>(
//      the value of this draggable is set using data
      data: listB[index],
//      the widget to show under the users finger being dragged
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index],
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
            listB[index],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//  builds the widgets for List A items
  Widget _buildListAItems(BuildContext context, int index) {
    return Draggable<String>(
      data: listA[index],
      feedback: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index],
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
            listA[index],
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
        return candidates.length > 0
            ? _buildDropPreview(context, candidates[0]!)
            : Container(
                width: 5,
                height: 5,
              );
      },
//      condition on to accept the item or not
      onWillAccept: (value) {
        if (listA.contains(value)) {
          setState(() {
            flagA = true; //print("list a to a ");
          });
        }
        if (listB.contains(value)) {
          setState(() {
            flagA = false; //print("list b to a ");
          });
        }

        return !listB.contains(value) || !listA.contains(value);
      },
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          if (flagA) {
            print("a to a ");
            listA.insert(index + 1, value);
            listA.remove(value);
          } else {
            listA.insert(index + 1, value);
            listB.remove(value);
          }
        });
      },
    );
  }

//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.length > 0
            ? _buildDropPreview(context, candidates[0]!)
            : Container(
                width: 5,
                height: 5,
              );
      },
      onWillAccept: (value) {
        if (listA.contains(value)) {
          setState(() {
            flagB = true; //print("list a to b ");
          });
        }
        if (listB.contains(value)) {
          setState(() {
            flagB = false; //print("list b to b ");
          });
        }

        return !listB.contains(value) || !listA.contains(value);
      },
      onAccept: (value) {
        setState(() {
          if (flagB) {
            print("a to b");
            listB.insert(index + 1, value);
            listA.remove(value);
          } else {
            listB.insert(index + 1, value);
            listB.remove(value);
          }
        });
      },
    );
  }

  Widget forms(List _firstListItems, List _secondListItems) {
    TextEditingController newValue = TextEditingController();
    TextEditingController indexController = TextEditingController();
    TextEditingController deleteIndex = TextEditingController();

    String dropdownvalue = 'List 1';
    String dropdownvalue2 = 'List 1';

    var items = [
      'List 1',
      'List 2',
    ];
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    String? err;
    return Column(
      children: [
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
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
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
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
                child: GestureDetector(
                  onTap: () async {
                    if (!_formKey2.currentState!.validate()) {
                      err = null;
                      return;
                    } else {
                      setState(() {
                        if (dropdownvalue2 == "List 2") {
                          _secondListItems.remove(int.parse(deleteIndex.text));

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
    );
  }
}