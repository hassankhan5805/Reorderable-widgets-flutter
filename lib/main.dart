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
  TextEditingController? list1Size = TextEditingController();
  TextEditingController? list2Size = TextEditingController();
  late List<String> _firstListItems = ["0", "1", "2", "3", "4", "5", "6", "7"];
  late List<String> _secondListItems = ["0", "1", "2", "3", "4", "5", "6", "7"];
  late final List _lists = [_firstListItems, _secondListItems];
  late int uniqueIdentifier = _firstListItems.length > _secondListItems.length
      ? _firstListItems.length
      : _secondListItems.length;

  func(int oldIndex, int newIndex, List listItems) {
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
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  late List<GlobalKey> scrollKeys = [_key1, _key2];
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  bool swaped = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Text("Enter List 1 size :"),
              Expanded(
                  child: TextField(
                controller: list1Size,
                keyboardType: TextInputType.number,
                onChanged: (a) {},
              ))
            ],
          ),
          Row(
            children: [
              Text("Enter List 2 size :"),
              Expanded(
                  child: TextField(
                controller: list2Size,
                keyboardType: TextInputType.number,
                onChanged: (y) {},
              ))
            ],
          ),
          ElevatedButton(
              onPressed: () {
                if (list1Size!.text.isNotEmpty) {
                  setState(() {
                    uniqueIdentifier =
                        int.parse(list1Size!.text) > _secondListItems.length
                            ? int.parse(list1Size!.text)
                            : _secondListItems.length;

                    _firstListItems = List<String>.generate(
                        int.parse(list1Size!.text), (int index) => "$index");
                  });
                }
                if (list2Size!.text.isNotEmpty) {
                  setState(() {
                    uniqueIdentifier =
                        _firstListItems.length > int.parse(list2Size!.text)
                            ? _firstListItems.length
                            : int.parse(list2Size!.text);
                    _secondListItems = List<String>.generate(
                        int.parse(list2Size!.text),
                        (int index) => "${index + uniqueIdentifier}");
                  });
                }
                list1Size!.clear();
                list2Size!.clear();
              },
              child: Text("Reset")),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 350,
            child: ReorderableListView(
              //shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  List<String> a = _firstListItems;
                  _firstListItems = _secondListItems;
                  _secondListItems = a;
                  swaped = !swaped;
                });
              },
              children: <Widget>[
                for (int index = 0; index < _lists.length; index += 1)
                  reOrderList(
                    _lists[index],
                    "$index",
                    index == 0 ? _buildListAItems : _buildListBItems,
                    index == 0 ? _buildDragTargetsA : _buildDragTargetsB,
                    index == 0
                        ? list1Size!.text.isEmpty
                            ? _firstListItems.length
                            : int.parse(list1Size!.text)
                        : _secondListItems.length,
                    index == 0 ? scrollController1 : scrollController2,
                    index == 0 ? _key1 : _key2,
                  )
              ],
            ),
          ),
          SizedBox(
            key: _key3,
          ),
          forms(_firstListItems, _secondListItems),
        ],
      ),
    );
  }

  listenerPosition(event) {
    RenderBox? box1 = _key1.currentContext!.findRenderObject() as RenderBox?;
    Offset listy1 = box1!.localToGlobal(Offset.zero);
    RenderBox? box2 = _key2.currentContext!.findRenderObject() as RenderBox?;
    Offset listy2 = box2!.localToGlobal(Offset.zero);
    RenderBox? box3 = _key3.currentContext!.findRenderObject() as RenderBox?;
    Offset listy3 = box3!.localToGlobal(Offset.zero);
    if (event.position.dx > MediaQuery.of(context).size.width - 25 &&
        event.position.dy > listy1.dy &&
        event.position.dy < listy2.dy) {
      scrollController1.animateTo(scrollController1.offset + 200,
          curve: Curves.ease, duration: const Duration(milliseconds: 400));
    } else if (event.position.dx < 25 &&
        event.position.dy > listy1.dy &&
        event.position.dy < listy2.dy) {
      scrollController1.animateTo(scrollController1.offset - 200,
          curve: Curves.ease, duration: const Duration(milliseconds: 400));
    } else if (event.position.dx > MediaQuery.of(context).size.width - 25 &&
        event.position.dy > listy2.dy &&
        event.position.dy < listy3.dy) {
      scrollController2.animateTo(scrollController2.offset + 200,
          curve: Curves.ease, duration: const Duration(milliseconds: 400));
    } else if (event.position.dx < 25 &&
        event.position.dy > listy2.dy &&
        event.position.dy < listy3.dy) {
      scrollController2.animateTo(scrollController2.offset - 200,
          curve: Curves.ease, duration: const Duration(milliseconds: 400));
    }
  }

  Widget _buildListBItems(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        listenerPosition(event);
      },
      child: LongPressDraggable<String>(
        data: _secondListItems[index],
        feedback: Container(
          color: index.isEven ? evenItemColor : oddItemColor,
          height: 80,
          width: 80,
          child: Center(
            child: Text(
              int.parse(_secondListItems[index]) > (uniqueIdentifier - 1)
                  ? "${int.parse(_secondListItems[index]) - uniqueIdentifier}"
                  : "${int.parse(_secondListItems[index])}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        childWhenDragging: Container(
          color: Colors.grey,
          width: 80,
          height: 80,
        ),
        child: Container(
          color: index.isEven ? evenItemColor : oddItemColor,
          height: 80,
          width: 80,
          child: Center(
            child: Text(
              int.parse(_secondListItems[index]) > (uniqueIdentifier - 1)
                  ? "${int.parse(_secondListItems[index]) - uniqueIdentifier}"
                  : "${int.parse(_secondListItems[index])}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListAItems(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        listenerPosition(event);
      },
      child: LongPressDraggable<String>(
        data: _firstListItems[index],
        feedback: Container(
          color: index.isEven ? evenItemColor : oddItemColor,
          width: 80,
          height: 80,
          child: Center(
            child: Text(
              int.parse(_firstListItems[index]) > uniqueIdentifier - 1
                  ? "${int.parse(_firstListItems[index]) - uniqueIdentifier}"
                  : "${int.parse(_firstListItems[index])}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        childWhenDragging: Container(
          color: Colors.grey,
          width: 80,
          height: 80,
        ),
        child: Container(
          color: index.isEven ? evenItemColor : oddItemColor,
          width: 80,
          height: 80,
          child: Center(
            child: Text(
              int.parse(_firstListItems[index]) > uniqueIdentifier - 1
                  ? "${int.parse(_firstListItems[index]) - uniqueIdentifier}"
                  : "${int.parse(_firstListItems[index])}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropPreview(BuildContext context, String value) {
    return Container(
      height: 80,
      width: 80,
      color: Colors.lightBlue[200],
      child: Center(
        child: Text(
          int.parse(value) > uniqueIdentifier
              ? "${int.parse(value) - uniqueIdentifier}"
              : "${int.parse(value)}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildDragTargetsA(BuildContext context, int index) {
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
        if (_firstListItems.contains(value)) {
          setState(() {
            flagA = false;
          });
        }
        if (_secondListItems.contains(value)) {
          setState(() {
            flagA = true;
          });
        }

        return true;
      },
      onAccept: (value) {
        setState(() {
          if (flagA) {
            _secondListItems.remove(value);
          } else {
            _firstListItems.remove(value);
          }
          _firstListItems.insert(index + 1, value);
        });
      },
    );
  }

  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<String>(
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
            flagB = true;
          });
        }
        if (_secondListItems.contains(value)) {
          setState(() {
            flagB = false;
          });
        }

        return true;
      },
      onAccept: (value) {
        setState(() {
          if (flagB) {
            _firstListItems.remove(value);
          } else {
            _secondListItems.remove(value);
          }
          _secondListItems.insert(index + 1, value);
        });
      },
    );
  }

  Widget reOrderList(final List listItems, String keys, _buildListItems,
      _buildDragTargets, len, scroll, GlobalKey scrollKey) {
    return SizedBox(
      key: Key(keys),
      height: 200,
      child: Column(
        children: [
          Container(
            height: 20,
            color: Colors.red,
          ),
          Expanded(
            child: SizedBox(
              width: listItems.length * 85,
              key: Key("$keys"),
              child: ListView.separated(
                key: scrollKey,
                controller: scroll,
                scrollDirection: Axis.horizontal,
                itemBuilder: _buildListItems,
                separatorBuilder: _buildDragTargets,
                itemCount: len,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget forms(_firstList, _secondList) {
    return Column(children: [
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
                    listLength = _firstList.length;
                  } else {
                    listLength = _secondList.length;
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
                        if (int.parse(newValue.text) < uniqueIdentifier) {
                          _secondList.insert(
                              int.parse(indexController.text), (newValue.text));
                        } else {
                          _secondList.insert(
                              int.parse(indexController.text),
                              (int.parse(newValue.text) + uniqueIdentifier)
                                  .toString()
                                  .trim());
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Item Added to list 2"),
                          backgroundColor: Colors.blue,
                        ));
                      } else if (dropdownvalue == "List 1") {
                        if (int.parse(newValue.text) < uniqueIdentifier) {
                          _firstList.insert(
                              int.parse(indexController.text), (newValue.text));
                        } else {
                          _firstList.insert(
                              int.parse(indexController.text),
                              (int.parse(newValue.text) + uniqueIdentifier)
                                  .toString()
                                  .trim());
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Item added to list 1"),
                          backgroundColor: Colors.blue,
                        ));
                      }
                    });
                    newValue.clear();
                    indexController.clear();
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
                    listLength = _firstList.length;
                  } else {
                    listLength = _secondList.length;
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
                        setState(() {
                          _secondList.removeAt(int.parse(deleteIndex.text));
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Item removed from list 2"),
                          backgroundColor: Colors.blue,
                        ));
                      } else if (dropdownvalue2.contains("List 1")) {
                        setState(() {
                          _firstList.removeAt(int.parse(deleteIndex.text));
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Item removed from list 1"),
                          backgroundColor: Colors.blue,
                        ));
                      }
                    });
                    deleteIndex.clear();
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
    ]);
  }
}
