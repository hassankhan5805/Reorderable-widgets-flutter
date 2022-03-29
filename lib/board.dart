// import 'package:flutter/material.dart';
// import 'package:reorderable/board.dart';
// import 'package:boardview/board_item.dart';
// import 'package:boardview/board_list.dart';
// import 'package:boardview/boardview_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:boardview/boardview.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(_title),
//           leading: IconButton(
//             icon: Icon(Icons.abc_outlined),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     maintainState: false,
//                     builder: (context) => BoardViewExample()),
//               );
//             },
//           ),
//         ),
//         body: BoardViewExample(),
//       ),
//     );
//   }
// }

// class BoardViewExample extends StatelessWidget {
//   List<BoardListObject> _listData = [
//     BoardListObject(title: "List title 1"),
//     BoardListObject(title: "List title 2"),
//     BoardListObject(title: "List title 3")
//   ];

//   //Can be used to animate to different sections of the BoardView
//   BoardViewController boardViewController = new BoardViewController();

//   @override
//   Widget build(BuildContext context) {
//     List<BoardList> _lists = [];
//     for (int i = 0; i < _listData.length; i++) {
//       _lists.add(_createBoardList(_listData[i]) as BoardList);
//     }
//     return BoardView(
//       lists: _lists,
//       boardViewController: boardViewController,
//     );
//   }

//   Widget buildBoardItem(BoardItemObject itemObject) {
//     return BoardItem(
//         onStartDragItem: (int? listIndex, int? itemIndex, BoardItemState state) {
        
//         },
//         onDropItem: (int? listIndex, int? itemIndex, int? oldListIndex,
//             int? oldItemIndex, BoardItemState state) {
                      
//         },
//         onTapItem: (int? listIndex, int? itemIndex, BoardItemState state) async {
        
//         },
//         item: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text("Board Item"),
//           ),
//         )
//     );
//   }

//   Widget _createBoardList(BoardListObject list) {
//     List<BoardItem> items = [];
//     print("object");
//     print(list.items!.length);
//     for (int i = 0; i < list.items!.length; i++) {
//       items.insert(i, buildBoardItem(list.items![i]) as BoardItem);
//     }

//     return BoardList(
//       onStartDragList: (int? listIndex) {
    
//       },
//       onTapList: (int? listIndex) async {
    
//       },
//       onDropList: (int? listIndex, int? oldListIndex) {       
       
//       },
//       headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
//       backgroundColor: Color.fromARGB(255, 235, 236, 240),
//       header: [
//         Expanded(
//             child: Padding(
//                 padding: EdgeInsets.all(5),
//                 child: Text(
//                   "List Item",
//                   style: TextStyle(fontSize: 20),
//                 ))),
//       ],
//       items: items,
//     );
//   }
// }

// class BoardItemObject {
//   String? title;

//   BoardItemObject({this.title}) {
//     if (this.title == null) {
//       this.title = "";
//     }
//   }
// }

// class BoardListObject {
//   String? title;
//   List<BoardItemObject>? items;

//   BoardListObject({this.title, this.items}) {
//     if (this.title == null) {
//       this.title = "";
//     }
//     if (this.items == null) {
//       this.items = [];
//     }
//   }
// }
