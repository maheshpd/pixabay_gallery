import 'dart:convert';

import 'package:pixabay_gallery/model/image_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '46329521-5b8125a6ed9eefd8727216e7f';
  static const String _baseUrl = 'https://pixabay.com/api/';

  /// This Dart function fetches a list of images from an API based on the specified page and perPage
  /// parameters.
  Future<List<ImageModel>> fetchImages({int page = 1, int perPage = 20}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl?key=$_apiKey&image_type=photo&pretty=true&page=$page&per_page=$perPage'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<ImageModel> images = [];
      for (var hit in data['hits']) {
        images.add(ImageModel.fromJson(hit));
      }
      return images;
    } else {
      throw Exception('Failed to load images');
    }
  }
}