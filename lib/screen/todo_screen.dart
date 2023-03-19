import 'package:cached_network_image/cached_network_image.dart';
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Obx(
            () => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 0.5,
                child: CachedNetworkImage(
                  imageUrl: todoController.backgroundImages.value,
                ),
              ),
            ),
          ),
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
