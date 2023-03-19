import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hobby_memo_app/constants/color_constants.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class SearchImageScreen extends StatefulWidget {
  const SearchImageScreen({super.key});

  @override
  SearchImageScreenState createState() => SearchImageScreenState();
}

class SearchImageScreenState extends State<SearchImageScreen> {
  String _searchText = '';
  List<Map<String, dynamic>> _images = [];
  static const String apiKey = '20160427-6fe8f1a22bcf30f938c3ce7aa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.appBarColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search images',
              ),
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
                // controller.inputText(text);
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                final image = _images[index];
                return GestureDetector(
                  onTap: () {
                    // print('${image['largeImageURL']}');
                    // controller.onTapBack(image['largeImageURL']);
                    //TODO 画面遷移で画像を渡してあげる
                    final result = image['largeImageURL'];
                    Navigator.pop(context, result);
                  },
                  child: CachedNetworkImage(
                    imageUrl: image['webformatURL'],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchImages,
        // onPressed: () => controller.searchImages(_searchText),
        child: const Icon(Icons.search),
      ),
    );
  }

  void _searchImages() async {
    final url = Uri.https('pixabay.com', '/api/', {
      'key': apiKey,
      'q': _searchText,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['hits'] != null) {
        setState(() {
          _images = List<Map<String, dynamic>>.from(data['hits']);
        });
      }
    }
  }
}
