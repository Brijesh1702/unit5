import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  runApp(const MaterialApp(home: HiveTodoApp()));
}

class HiveTodoApp extends StatefulWidget {
  const HiveTodoApp({super.key});
  @override
  State<HiveTodoApp> createState() => _HiveTodoAppState();
}

class _HiveTodoAppState extends State<HiveTodoApp> {
  final TextEditingController _controller = TextEditingController();
  final Box _todoBox = Hive.box('todoBox');

  _addTodo() {
    if (_controller.text.isNotEmpty) {
      _todoBox.add(_controller.text);
      _controller.clear();
      setState(() {});
    }
  }

  _deleteTodo(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive: To-Do Notes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter Note",
                suffixIcon: IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _todoBox.listenable(),
              builder: (context, Box box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final note = box.getAt(index);
                    return ListTile(
                      title: Text(note),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTodo(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
