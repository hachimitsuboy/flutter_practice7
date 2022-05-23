import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_screen.dart';

class EditScreen extends ConsumerWidget {


  final TextEditingController _todoController = TextEditingController();
  var _deadLine = DateTime.now();
  final dropDownProvider = StateProvider((ref) {
    return 1;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("編集画面"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text("やること", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: TextField(
                controller: _todoController,
                maxLength: 20,
                decoration: const InputDecoration(
                  hintText: "例: ご飯を炊く",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("優先度", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 3,
                  child: Text("低"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("中"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("高"),
                ),
              ],
              onChanged: (value) =>
                  ref.read(dropDownProvider.notifier).state = value as int,
              value: ref.watch(dropDownProvider),
            ),
            const SizedBox(height: 20),
            const Text("締切", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                DatePicker.showDatePicker(context, showTitleActions: true,
                    onConfirm: (date) {
                  _deadLine = date;
                });
              },
              child: const Icon(Icons.date_range),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: 230,
              child: ElevatedButton(
                onPressed: () => _registerTodo(context, ref),
                child: const Text(
                  "Todoを作成",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _registerTodo(BuildContext context, WidgetRef ref) {
    print(
        "TodoName: ${_todoController.text} / priority: ${ref.read(dropDownProvider)} / deadLine: $_deadLine");
    final todo = Todo(
      todoName: _todoController.text,
      completed: 1,
      priority: ref.watch(dropDownProvider),
      deadLine: _deadLine,
    );

    //read→watch
    ref.read(todosProvider.notifier).add(todo);
    Navigator.pop(context);
  }
}
