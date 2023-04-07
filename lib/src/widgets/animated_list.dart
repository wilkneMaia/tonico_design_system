// linck: https://www.youtube.com/watch?v=bIiFjTL5YM4

import 'package:flutter/material.dart';

class TonicoAnimatedList extends StatelessWidget {
  const TonicoAnimatedList({super.key});

  @override
  Widget build(BuildContext context) {
    // items in the list
    // ignore: no_leading_underscores_for_local_identifiers
    final _items = [];

    // ignore: no_leading_underscores_for_local_identifiers
    final GlobalKey<AnimatedListState> _key = GlobalKey();

    void _addItem() {
      _items.insert(0, "Item ${_items.length + 1}");
      _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
    }

    return AnimatedList(
      key: _key,
      initialItemCount: 0,
      padding: const EdgeInsets.all(10),
      itemBuilder: (_, index, animation) {
        return SizeTransition(
          key: UniqueKey(),
          sizeFactor: animation,
          child: Card(
            margin: const EdgeInsets.all(10),
            elevation: 10,
            color: Colors.blue,
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              title: Text(_items[index],
                  style: const TextStyle(fontSize: 24, color: Colors.white)),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent.withOpacity(0.9),
                ),
                onPressed: () {},
                // onPressed: () => _removeItem(index),
              ),
            ),
          ),
        );
      },
    );
  }

  // void _removeItem(int index) {
  //   _key.currentState!.removeItem(index, (_, animation) {
  //     return SizeTransition(
  //       sizeFactor: animation,
  //       child: const Card(
  //         margin: EdgeInsets.all(10),
  //         elevation: 10,
  //         color: Colors.purple,
  //         child: ListTile(
  //           contentPadding: EdgeInsets.all(15),
  //           title: Text("removing", style: TextStyle(fontSize: 24)),
  //         ),
  //       ),
  //     );
  //   }, duration: const Duration(seconds: 1));

  //   _items.removeAt(index);
  // }
}
