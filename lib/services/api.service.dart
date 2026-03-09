import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class IQService {
  static const String baseUrl = "https://smartiq.ideacipher.com/index.php/API/";

  /// categories ---------------------------------------------------------------

  static Future<List<dynamic>> fetchCategories(
    String categoryId,
    String token,
  ) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "${baseUrl}getCategory",
        data: {"module": categoryId},
        options: Options(
          headers: {"Content-Type": "application/json", "token": token},
        ),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        if (data is Map && data['status'] == "S100" && data['data'] != null) {
          final List<dynamic> items = data['data'];
          return items;
        } else {}
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('[IQService][fetchQuestion] exception: $e');
      }
      return [];
    }
  }

  /// Question -----------------------------------------------------------------

  static Future<dynamic> fetchQuestion(
    String categoryId,
    String levelId,
    String token,
  ) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}getQuestion",
        data: {"cat_id": categoryId, "level_id": levelId},
        options: Options(
          headers: {"Content-Type": "application/json", "token": token},
        ),
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      if (response.statusCode == 200 && data['status'] == "S100") {
        final dynamic payload = data['data'];
        return payload;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
