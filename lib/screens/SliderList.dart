// import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
// import 'package:flutter/material.dart';
//
// class KanbanList extends StatefulWidget {
//   const KanbanList({Key? key}) : super(key: key);
//
//   @override
//   _KanbanListState createState() => _KanbanListState();
// }
//
// class _KanbanListState extends State<KanbanList> {
//   List<DragAndDropList> lists = [
//     DragAndDropList(
//       header: Text('To Do', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//       children: [
//         DragAndDropItem(
//           child: Card(child: ListTile(title: Text('Task 1'))),
//         ),
//         DragAndDropItem(
//           child: Card(child: ListTile(title: Text('Task 2'))),
//         ),
//       ],
//     ),
//     DragAndDropList(
//       header: Text('In Progress', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//       children: [
//         DragAndDropItem(
//           child: Card(child: ListTile(title: Text('Task 3'))),
//         ),
//       ],
//     ),
//     DragAndDropList(
//       header: Text('Done', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//       children: [
//         DragAndDropItem(
//           child: Card(child: ListTile(title: Text('Task 4'))),
//         ),
//       ],
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width, // Set width to fit the screen
//             child: DragAndDropLists(
//               children: lists,
//               onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
//                 setState(() {
//                   final item = lists[oldListIndex].children.removeAt(oldItemIndex);
//                   lists[newListIndex].children.insert(newItemIndex, item);
//                 });
//               },
//               onListReorder: (oldListIndex, newListIndex) {
//                 setState(() {
//                   final list = lists.removeAt(oldListIndex);
//                   lists.insert(newListIndex, list);
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }