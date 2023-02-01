import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/models/photo_list_response.dart';
import 'package:wallpaper_app/models/photo_type.dart';

class DataService {
  final _baseUrl = 'api.unsplash.com';
  final _apiKey = 'ka__PyBLAlgMgeFiUoL7knkB5zQJXufW2xrXgrsNuKM';

  /// Get photos from Unsplash server
  ///
  /// [pageNumber] : page to get from server
  ///
  /// [sortType] : any value from [PhotoSort] (default [PhotoSort.LATEST])
  Future<List<PhotoListItem>> getPhotos(int pageNumber,
      {PhotoSort sortType = PhotoSort.LATEST}) async {
    //https://api.unsplash.com/photos?page={pageNumber}&per_page={pageLimit}&order_by={sortType}&client_id={API_KEY}

    const pageLimit = 20;
    var orderBy = '';
    switch (sortType) {
      case PhotoSort.POPULAR:
        orderBy = 'popular';
        break;
      case PhotoSort.LATEST:
        orderBy = 'latest';
        break;
      case PhotoSort.OLDEST:
        orderBy = 'oldest';
        break;
    }

    final queryParameters = {
      'page': '$pageNumber',
      'per_page': '$pageLimit',
      'order_by': orderBy,
      'client_id': _apiKey
    };

    try {
      final uri = Uri.https(_baseUrl, '/photos', queryParameters);
      final response = await http.get(uri);

      // printing response in DEBUG mode
      if (kDebugMode) {
        print(pageNumber);
        print(response.body);
      }

      final json = jsonDecode(response.body) as List;
      final photos = json.map((photoItemJson) => PhotoListItem.fromJSON(photoItemJson)).toList();
      return photos;
    } catch(e) {
      rethrow;
    }
  }

  /// Get topic wise photos from Unsplash server
  ///
  /// [pageNumber] : page to get from server
  ///
  /// [topicName] : name of category (topic_slug)
  Future<List<PhotoListItem>> getTopicWisePhotos(int pageNumber, String topicName, PhotoSort sortType) async {
    //https://api.unsplash.com/topics/{topicName}/photos?page={pageNumber}&per_page={pageLimit}&order_by={sortType}&client_id={API_KEY}

    const pageLimit = 20;
    var orderBy = 'popular';
    switch (sortType) {
      case PhotoSort.POPULAR:
        orderBy = 'popular';
        break;
      case PhotoSort.LATEST:
        orderBy = 'latest';
        break;
      case PhotoSort.OLDEST:
        orderBy = 'oldest';
        break;
    }

    final queryParameters = {
      'page': '$pageNumber',
      'per_page': '$pageLimit',
      'order_by': orderBy,
      'orientation': 'portrait',
      'client_id': _apiKey
    };

    try {
      final uri = Uri.https(
          _baseUrl, '/topics/$topicName/photos', queryParameters);
      final response = await http.get(uri);

      // printing response in DEBUG mode
      if (kDebugMode) {
        print(response.body);
      }

      final json = jsonDecode(response.body) as List;
      final photos = json.map((photoItemJson) => PhotoListItem.fromJSON(photoItemJson)).toList();
      return photos;
    } catch (e) {
      rethrow;
    }
  }
}
