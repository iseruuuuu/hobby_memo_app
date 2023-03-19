import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobby_memo_app/constants/color_constants.dart';
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
        backgroundColor: ColorConstant.appBarColor,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(todoController.backgroundImage.value),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Stack(
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
              padding: const EdgeInsets.only(bottom: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ActionButton(
                    label: 'delete done',
                    icon: Icons.delete,
                    color: Colors.grey,
                    onPressed: () {
                      if (!filterController.hideDone) {
                        todoController.deleteDone();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            backgroundColor: ColorConstant.appBarColor,
            onPressed: todoController.pickImageFromGallery,
            child: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 30),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: ColorConstant.appBarColor,
            onPressed: todoController.onTapAdd,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
