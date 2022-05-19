import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:stream_provider/edit_screen.dart';

class Todo {
  final String todoName;
  final int completed;
  final int priority;
  final DateTime deadLine;

  Todo({
    required this.todoName,
    required this.completed,
    required this.priority,
    required this.deadLine,
  });
}

final List<Todo> _todoList = [];

enum SortType {
  completed,
  priority,
  deadLine,
}

final sortTypeProvider = StateProvider((ref) => SortType.completed);
final todosProvider = Provider((ref) {
  return _todoList;
});

final sortTodosProvider = Provider((ref) {
  final sortType = ref.watch(sortTypeProvider);
  //EditScreenでtodoList(todosProvider)が追加されたことを監視しリビルドされる
  final todoList = ref.watch(todosProvider);
  print("_todoListの要素数${todoList.length}");

  switch (sortType) {
    case SortType.completed:
      todoList.sorted((a, b) => a.completed.compareTo(b.completed));
      return todoList;
    case SortType.priority:
      todoList.sorted((a, b) => a.priority.compareTo(b.priority));
      return todoList;
    case SortType.deadLine:
      todoList.sorted((a, b) => a.deadLine.compareTo(b.deadLine));
      return todoList;
  }
});

class TodoScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    //監視とリビルド
    // final todos = ref.watch(sortTodosProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todoリスト"),
      ),
      body: ListView.builder(
        itemCount: ref.watch(sortTodosProvider).length,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.check),
              title: Text(ref.read(todosProvider)[index].todoName),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addTodo(context),
      ),
    );
  }

  //編集画面へ移動
  _addTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditScreen(todoList: _todoList),
      ),
    );
  }
}
