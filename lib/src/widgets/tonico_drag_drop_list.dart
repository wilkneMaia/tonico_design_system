import 'package:flutter/material.dart';

class TonicoDragDropList extends StatefulWidget {
  const TonicoDragDropList({super.key});

  @override
  State<TonicoDragDropList> createState() => _TonicoDragDropListState();
}

class _TonicoDragDropListState extends State<TonicoDragDropList> {
  // list of titles
  final List myTiles = ['A', 'B', 'C'];

  // reorder metod
  void updateMyTiles(int oldIndex, int newIndex) {
    // an adjustment is neeed when moving the tile down the list
    if (oldIndex < newIndex) {
      newIndex--;
    }
    // get the tile we are moving
    final tile = myTiles.removeAt(oldIndex);

    // place the tile n the new position
    myTiles.insert(newIndex, tile);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: [
        for (final tile in myTiles)
          ListTile(
            key: ValueKey(tile),
            title: Text(tile),
          )
      ],
      onReorder: (oldIndex, newIndex) => updateMyTiles(oldIndex, newIndex),
    );
  }
}
