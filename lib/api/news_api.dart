import 'dart:convert';
import 'package:almoterfy/api/news_model.dart';
import 'package:almoterfy/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<PostNews>? fetchNews(int gid) async {
  final response = await http.get(
    Uri.https('almoterfy.com', '/api/article', {'gid': gid.toString()}),
  );
  if (response.statusCode == 200) {
    Constants.changeCategory = true;
    Constants.refreshNews = false;

    return PostNews.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load Posts');
  }
}

Future<PostNewsContent>? fetchNewsContent(int newsTag) async {
  final response = await http.post(
    Uri.https(
        'almoterfy.com', '/api/article/content', {'id': newsTag.toString()}),
  );
  if (response.statusCode == 200) {
    return PostNewsContent.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load Posts');
  }
}

Future<Search>? fetchSearchItem(
  String searchWord,
  String searchInTitle,
  String searchInText,
) async {
  debugPrint(searchWord + searchInText + searchInTitle);

  final response = await http.get(
    Uri.https('almoterfy.com', '/api/article', {
      'sw': searchWord,
      'sctxt': searchInText,
      'sctitle': searchInTitle,
    }),
  );
  debugPrint(response.statusCode.toString());
  if (response.statusCode == 200) {
    return Search.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load Posts');
  }
}

Future<CategoryResponse>? fetchCategories() async {
  // Send GET request
  final response = await http.get(
    Uri.https('almoterfy.com', '/api/article/category'),
  );

  if (response.statusCode == 200) {
    // Parse JSON into model
    return CategoryResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load categories');
  }
}
