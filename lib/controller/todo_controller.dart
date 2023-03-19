import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:hobby_memo_app/controller/filter_controller.dart';
import 'package:hobby_memo_app/model/todo.dart';
import 'package:hobby_memo_app/screen/search_image_screen.dart';
import 'package:hobby_memo_app/screen/todo_add_screen.dart';
import 'package:hobby_memo_app/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoController extends GetxController {
  final _todos = <Todo>[].obs;

  final _storage = TodoStorage();
  late final Worker _worker;
  late Rx<File> backgroundImage = File('').obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final storageTodos =
        _storage.load()?.map((json) => Todo.fromJson(json)).toList();
    final initialTodos = storageTodos ?? Todo.initialTodos;
    _todos.addAll(initialTodos);

    _worker = ever<List<Todo>>(_todos, (todos) {
      final data = todos.map((e) => e.toJson()).toList();
      _storage.save(data);
    });
    _loadBackgroundImage();
  }

  _loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imagePath = prefs.getString('backgroundImage') ?? '';
    backgroundImage.value = File(imagePath);
  }

  Future pickImageFromGallery() async {
    Get.to(() => const SearchImageScreen())?.then((value) {
      print(value);
      _saveBackgroundImage(value);
      backgroundImage.value = File(value.toString());
    });
  }

  _saveBackgroundImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundImage', imagePath);
  }

  @override
  void onClose() {
    _worker.dispose();
    super.onClose();
  }

  List<Todo> get todos {
    final hideDone = Get.find<FilterController>().hideDone;
    if (hideDone) {
      return _todos.where((todo) => todo.done == false).toList();
    } else {
      return _todos;
    }
  }

  int get countUndone {
    return _todos.fold<int>(0, (acc, todo) {
      if (!todo.done) {
        acc++;
      }
      return acc;
    });
  }

  Todo? getTodoById(String id) {
    try {
      return _todos.singleWhere((e) => e.id == id);
    } on StateError {
      return null; // 該当IDがなければnullを返す
    }
  }

  void addTodo(String description) {
    final todo = Todo(description: description);
    _todos.add(todo);
  }

  void updateText(String description, Todo todo) {
    final index = _todos.indexOf(todo);
    final newTodo = todo.copyWith(description: description);
    _todos.setAll(index, [newTodo]);
  }

  void updateDone(bool done, Todo todo) {
    final index = _todos.indexOf(todo);
    final newTodo = todo.copyWith(done: done);
    _todos.setAll(index, [newTodo]);
  }

  void remove(Todo todo) {
    _todos.remove(todo);
  }

  void deleteDone() {
    _todos.removeWhere((e) => e.done == true);
  }

  void onTapAdd() {
    Get.to(() => const TodoAddScreen());
  }
}
