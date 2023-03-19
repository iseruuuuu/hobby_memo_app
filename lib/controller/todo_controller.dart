import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:hobby_memo_app/controller/filter_controller.dart';
import 'package:hobby_memo_app/model/todo.dart';
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      backgroundImage.value = File(pickedFile.path);
      _saveBackgroundImage(pickedFile.path);
    }
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

  // FilterControllerの状態次第で表示タスクを変更
  List<Todo> get todos {
    final hideDone = Get.find<FilterController>().hideDone;
    if (hideDone) {
      return _todos.where((todo) => todo.done == false).toList();
    } else {
      return _todos;
    }
  }

  // 未完了タスクの数取得
  int get countUndone {
    return _todos.fold<int>(0, (acc, todo) {
      if (!todo.done) {
        acc++;
      }
      return acc;
    });
  }

  // IDからTodoを取得
  Todo? getTodoById(String id) {
    try {
      return _todos.singleWhere((e) => e.id == id);
    } on StateError {
      return null; // 該当IDがなければnullを返す
    }
  }

  // Todo新規作成
  void addTodo(String description) {
    final todo = Todo(description: description);
    _todos.add(todo);
  }

  // Todoのテキスト更新
  void updateText(String description, Todo todo) {
    final index = _todos.indexOf(todo);
    final newTodo = todo.copyWith(description: description);
    _todos.setAll(index, [newTodo]);
  }

  // Todoの完了状況更新
  void updateDone(bool done, Todo todo) {
    final index = _todos.indexOf(todo);
    final newTodo = todo.copyWith(done: done);
    _todos.setAll(index, [newTodo]);
  }

  // 指定タスクを削除
  void remove(Todo todo) {
    _todos.remove(todo); // 等価性overrideしたのでOK
  }

  // 完了タスクを一括削除
  void deleteDone() {
    _todos.removeWhere((e) => e.done == true);
  }

  void onTapAdd() {
    Get.to(() => const TodoAddScreen());
  }
}
