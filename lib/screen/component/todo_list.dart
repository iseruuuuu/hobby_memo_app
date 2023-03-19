import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobby_memo_app/controller/todo_controller.dart';
import 'package:hobby_memo_app/model/todo.dart';
import 'package:hobby_memo_app/screen/component/todo_check_box.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // Get.toNamed('/todo/${todo.id}');
        //TODO Todo詳細画面に飛ぶようにする
      },
      leading: TodoCheckbox(todo),
      title: Text(
        todo.description,
        style: todo.done
            ? const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
              )
            : const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
      ),
      trailing: IconButton(
        onPressed: () {
          Get.find<TodoController>().remove(todo);
        },
        icon: const Icon(
          Icons.delete,
          size: 25,
          color: Colors.grey,
        ),
      ),
    );
  }
}
