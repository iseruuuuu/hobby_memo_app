import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SearchImageScreenController extends GetxController {

  RxString searchText = ''.obs;
  RxList<Map<String, dynamic>> images = <Map<String, dynamic>>[].obs;
  static const String apiKey = '20160427-6fe8f1a22bcf30f938c3ce7aa';

  void inputText(String text) {
    searchText.value = text;
  }

  void searchImages(String searchText) async {
    final url = Uri.https('pixabay.com', '/api/', {
      'key': apiKey,
      'q': searchText,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['hits'] != null) {
          images.value = List<Map<String, dynamic>>.from(data['hits']);
      }
    }
  }

  void onTapBack(String image) {
    Get.back(result: image);
  }
}
