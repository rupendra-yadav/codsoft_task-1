import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/database/local_database.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/tiles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mybox = Hive.box('mybox');

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db.createIntialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final _textController = TextEditingController();

  ToDoDatabase db = ToDoDatabase();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  void saveTask() {
    setState(() {
      db.todoList.add([_textController.text, false]);
      _textController.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void createtask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _textController,
            onsave: saveTask,
          );
        });
  }

  deletetask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TODO",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: createtask,
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: db.todoList.length,
          itemBuilder: (context, index) => TaskTile(
            taskName: db.todoList[index][0],
            taskStatus: db.todoList[index][1],
            onPressed: (value) => checkBoxChanged(value, index),
            delete: (context) => deletetask(index),
          ),
        ),
      ),
    );
  }
}
