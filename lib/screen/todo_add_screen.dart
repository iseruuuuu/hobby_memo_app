import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobby_memo_app/constants/color_constants.dart';
import 'package:hobby_memo_app/controller/todo_controller.dart';
import 'package:hobby_memo_app/model/todo.dart';
import 'package:hobby_memo_app/screen/component/todo_action_button.dart';

class TodoAddScreen extends StatefulWidget {
  final String? todoId;

  const TodoAddScreen({Key? key, this.todoId}) : super(key: key);

  @override
  TodoAddScreenState createState() => TodoAddScreenState();
}

class TodoAddScreenState extends State<TodoAddScreen> {
  final todoController = Get.find<TodoController>();
  final textController = TextEditingController();
  Todo? todo;

  @override
  void initState() {
    super.initState();
    if (widget.todoId != null) {
      todo = todoController.getTodoById(widget.todoId!);
      if (todo != null) {
        textController.text = todo!.description;
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.appBarColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              final text = textController.text;
              if (todo == null && text.isNotEmpty) {
                todoController.addTodo(text);
              } else if (todo != null) {
                todoController.updateText(text, todo!);
              }
              Get.back();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'タスクの入力',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 20),
                  maxLines: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
