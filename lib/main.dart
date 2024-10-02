import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReorderableList(),
    );
  }
}

class AnimatedListCustom extends StatefulWidget {
  // linck: https://www.youtube.com/watch?v=bIiFjTL5YM4
  const AnimatedListCustom({super.key});

  @override
  State<AnimatedListCustom> createState() => _AnimatedListCustomState();
}

class _AnimatedListCustomState extends State<AnimatedListCustom> {
  // items in the list
  final _items = [];
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _addItem() {
    _items.insert(0, "Item ${_items.length + 1}");
    _key.currentState!.insertItem(0, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated List'),
      ),
      body: AnimatedList(
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
                  onPressed: () => _removeItem(index),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addItem, child: const Icon(Icons.add)),
    );
  }

  void _removeItem(int index) {
    _key.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.purple,
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text("removing", style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    }, duration: const Duration(seconds: 1));

    _items.removeAt(index);
  }
}

class ReorderableList extends StatelessWidget {
  const ReorderableList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tilulo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TonicoReorderableList<String>(
              items: const ['A', 'B', 'C'],
              itemBuilder: (item) => ListTile(
                key: ValueKey(item),
                title: Text(item),
              ),
              onReorder: (items) {
                // faça algo com a nova lista de itens
                print(items);
              },
            ),
          ),
          SlideAction(
            borderRadius: 12,
            elevation: 0,
            innerColor: Colors.deepPurple,
            outerColor: Colors.deepPurple[200],
            sliderButtonIcon: const Icon(
              Icons.looks,
              color: Colors.white,
            ),
            text: 'Slide to Unlock',
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            // sliderRotate: false,
            onSubmit: () {},
          )
        ],
      ),
    );
  }
}

/// Um widget de lista reordenável.
class TonicoReorderableList<T> extends StatefulWidget {
  /// A lista de itens a serem exibidos.
  final List<T> items;

  /// A função que constrói cada item da lista.
  final Widget Function(T item) itemBuilder;

  /// A função que é chamada quando os itens são reordenados.
  final void Function(List<T> items) onReorder;

  /// Cria um novo [ReorderableList] com os itens fornecidos.
  const TonicoReorderableList({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TonicoReorderableListState<T> createState() =>
      _TonicoReorderableListState<T>();
}

class _TonicoReorderableListState<T> extends State<TonicoReorderableList<T>> {
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  void _updateItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    final items = List.of(_items);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    setState(() {
      _items = items;
      widget.onReorder(_items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: [
        for (final item in _items) widget.itemBuilder(item),
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          _updateItems(oldIndex, newIndex);
          widget.onReorder(_items);
        });
      },
    );
  }
  //  items: uma lista de itens que serão exibidos na lista;
  // itemBuilder: uma função que recebe um item e retorna o widget que será exibido na lista para aquele item;
  // onReorder: uma função que será chamada quando os itens forem reordenados. Essa função recebe a nova lista de itens.
  // https://www.youtube.com/watch?v=wwUR7841Ajs
}
