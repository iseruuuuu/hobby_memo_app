import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobby_memo_app/screen/tab_screen.dart';
import 'package:hobby_memo_app/service/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabScreen(),
    );
  }
}
