import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobby_memo_app/controller/filter_controller.dart';
import 'package:hobby_memo_app/controller/todo_controller.dart';
import 'package:hobby_memo_app/screen/component/todo_action_button.dart';
import 'package:hobby_memo_app/screen/component/todo_list.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoController = Get.put(TodoController());
    final filterController = Get.put(FilterController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        leading: IconButton(
          icon: Obx(
            () => Icon(
              filterController.hideDone
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
          ),
          onPressed: filterController.toggleHide,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(
            () {
              final todos = todoController.todos;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoTile(key: Key(todo.id), todo: todo);
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionButton(
                  label: 'delete_done'.tr,
                  icon: Icons.delete,
                  color: Colors.grey,
                  onPressed: () {
                    if (!filterController.hideDone) {
                      todoController.deleteDone();
                    }
                  },
                ),
                ActionButton(
                  label: 'add_new'.tr,
                  icon: Icons.add,
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () => todoController.onTapAdd(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
