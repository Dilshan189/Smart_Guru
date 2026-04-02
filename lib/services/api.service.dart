import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CommerceService {
  static const String baseUrl =
      "https://commerce.ideacipher.com/index.php/API/";

  /// Auth ---------------------------------------------------------------------

  static Future<dynamic> login(String phone) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}login",
        data: {"phone": phone},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      var data = response.data;
      if (data is String) {
        String trimmed = data.trim();
        if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
          data = jsonDecode(data);
        } else {
          if (kDebugMode) {
            print('[CommerceService][login] Non-JSON response received: $data');
          }
          return {
            "status": "E100",
            "data": "Server error: Received invalid response format.",
          };
        }
      }
      return data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          '[CommerceService][login] DioException: ${e.response?.data ?? e.message}',
        );
      }
      if (e.response != null && e.response?.data != null) {
        var data = e.response!.data;
        if (data is String) {
          String trimmed = data.trim();
          if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
            data = jsonDecode(data);
          } else {
            return {"status": "E100", "data": "Server error: ${e.message}"};
          }
        }
        return data;
      }
      return {"status": "E100", "data": "Network Error: ${e.message}"};
    } catch (e) {
      if (kDebugMode) {
        print('[CommerceService][login] exception: $e');
      }
      return {"status": "E100", "data": "An unexpected error occurred."};
    }
  }

  /// register ---------------------------------------------------------------

  static Future<dynamic> register(
    String name,
    String phone, {
    String? couponCode,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {"name": name, "phone": phone};
      if (couponCode != null && couponCode.isNotEmpty) {
        body["coupon_code"] = couponCode;
      }

      final response = await dio.post(
        "${baseUrl}register",
        data: body,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      return data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          '[CommerceService][register] DioException: ${e.response?.data ?? e.message}',
        );
      }
      if (e.response != null && e.response?.data != null) {
        var data = e.response!.data;
        if (data is String) data = jsonDecode(data);
        return data;
      }
      return {"status": "E100", "data": "Network Error: ${e.message}"};
    } catch (e) {
      if (kDebugMode) {
        print('[CommerceService][register] exception: $e');
      }
      return null;
    }
  }

  /// Category -----------------------------------------------------------------

  static Future<List<dynamic>> getCategory({
    int? categoryId,
    String? module,
    String? status,
    int? isPremium,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (categoryId != null) body['category_id'] = categoryId;
      if (module != null) body['module'] = module;
      if (status != null) body['status'] = status;
      if (isPremium != null) body['is_premium'] = isPremium;

      final response = await dio.post(
        "${baseUrl}getCategory",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) {
        String trimmed = data.trim();
        if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
          data = jsonDecode(data);
        } else {
          return [];
        }
      }

      if (data is Map && data['status'] == "S100" && data['data'] != null) {
        return data['data'] as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          '[CommerceService][getCategory] DioException: ${e.response?.data ?? e.message}',
        );
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('[CommerceService][getCategory] exception: $e');
      }
      return [];
    }
  }

  /// Paragraph ----------------------------------------------------------------

  static Future<List<dynamic>> getParagraph({
    int? paragraphId,
    int? catId,
    int? levelId,
    int? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (paragraphId != null) body['paragraph_id'] = paragraphId;
      if (catId != null) body['cat_id'] = catId;
      if (levelId != null) body['level_id'] = levelId;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getParagraph",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Question -----------------------------------------------------------------

  static Future<dynamic> getQuestion({
    int? questionId,
    int? catId,
    int? levelId,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (questionId != null) body['question_id'] = questionId;
      if (catId != null) body['cat_id'] = catId;
      if (levelId != null) body['level_id'] = levelId;

      final response = await dio.post(
        "${baseUrl}getQuestion",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Question Reports ---------------------------------------------------------

  static Future<List<dynamic>> getQuestionReports({
    int? reportId,
    int? questionId,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (reportId != null) body['report_id'] = reportId;
      if (questionId != null) body['question_id'] = questionId;

      final response = await dio.post(
        "${baseUrl}getQuestionReports",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject ------------------------------------------------------------------

  static Future<List<dynamic>> getSubject({
    int? subjectId,
    String? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (subjectId != null) body['subject_id'] = subjectId;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getSubject",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Lesson -----------------------------------------------------------

  static Future<List<dynamic>> getSubjectLesson({
    int? lessonId,
    int? subjectId,
    String? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (lessonId != null) body['lesson_id'] = lessonId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getSubjectLesson",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Lesson Level -----------------------------------------------------

  static Future<List<dynamic>> getSubjectLessonLevel({
    int? levelId,
    int? lessonId,
    int? subjectId,
    String? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (levelId != null) body['level_id'] = levelId;
      if (lessonId != null) body['lesson_id'] = lessonId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getSubjectLessonLevel",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Lesson Question --------------------------------------------------

  static Future<List<dynamic>> getSubjectLessonQuestion({
    int? questionId,
    int? subjectId,
    int? lessonId,
    int? levelId,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (questionId != null) body['question_id'] = questionId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (lessonId != null) body['lesson_id'] = lessonId;
      if (levelId != null) body['level_id'] = levelId;

      final response = await dio.post(
        "${baseUrl}getSubjectLessonQuestion",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Paper ------------------------------------------------------------

  static Future<List<dynamic>> getSubjectPaper({
    int? paperId,
    int? subjectId,
    String? paperType,
    String? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (paperId != null) body['paper_id'] = paperId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (paperType != null) body['paper_type'] = paperType;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getSubjectPaper",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Paper Question ---------------------------------------------------

  static Future<List<dynamic>> getSubjectPaperQuestion({
    int? questionId,
    int? paperId,
    int? subjectId,
    String? paperType,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (questionId != null) body['question_id'] = questionId;
      if (paperId != null) body['paper_id'] = paperId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (paperType != null) body['paper_type'] = paperType;

      final response = await dio.post(
        "${baseUrl}getSubjectPaperQuestion",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Short Note -------------------------------------------------------

  static Future<List<dynamic>> getSubjectShortNote({
    int? shortNoteId,
    int? subjectId,
    String? status,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (shortNoteId != null) body['short_note_id'] = shortNoteId;
      if (subjectId != null) body['subject_id'] = subjectId;
      if (status != null) body['status'] = status;

      final response = await dio.post(
        "${baseUrl}getSubjectShortNote",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subject Module Mobile (Aggregate) ----------------------------------------

  static Future<List<dynamic>> getSubjectModuleMobile({
    int? subjectId,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (subjectId != null) body['subject_id'] = subjectId;

      final response = await dio.post(
        "${baseUrl}getSubjectModuleMobile",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// User Points --------------------------------------------------------------

  static Future<dynamic> getUserPoints(int userId, String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}getUserPoints",
        data: {"user_id": userId},
        options: Options(
          headers: {"Content-Type": "application/json", "token": token},
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Leaderboard --------------------------------------------------------------

  static Future<dynamic> getLeaderboard(int userId, String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}getLeaderboard",
        data: {"user_id": userId},
        options: Options(
          headers: {"Content-Type": "application/json", "token": token},
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Level --------------------------------------------------------------------

  static Future<List<dynamic>> getLevel({
    int? levelId,
    int? categoryId,
    int? isPremium,
    String? questionType,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (levelId != null) body['level_id'] = levelId;
      if (categoryId != null) body['category_id'] = categoryId;
      if (isPremium != null) body['is_premium'] = isPremium;
      if (questionType != null) body['question_type'] = questionType;

      final response = await dio.post(
        "${baseUrl}getLevel",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map && data['status'] == "S100" && data['data'] != null) {
        return data['data'] as List<dynamic>;
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print(
          '[CommerceService][getLevel] DioException: ${e.response?.data ?? e.message}',
        );
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('[CommerceService][getLevel] exception: $e');
      }
      return [];
    }
  }

  /// Dashboard & Payments -----------------------------------------------------

  static Future<dynamic> getDashboardSummary(String token) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}getDashboardSummary",
        options: Options(
          headers: {"Content-Type": "application/json", "token": token},
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getDashboardData({int? limit, String? token}) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${baseUrl}getDashboardData",
        data: limit != null ? {"limit": limit} : {},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// payment

  static Future<List<dynamic>> getPayment({
    int? paymentId,
    int? userId,
    String? paymentStatus,
    String? paymentMethod,
    String? token,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> body = {};
      if (paymentId != null) body['payment_id'] = paymentId;
      if (userId != null) body['user_id'] = userId;
      if (paymentStatus != null) body['payment_status'] = paymentStatus;
      if (paymentMethod != null) body['payment_method'] = paymentMethod;

      final response = await dio.post(
        "${baseUrl}getPayment",
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null) "token": token,
          },
        ),
      );

      var data = response.data;
      if (data is String) data = jsonDecode(data);
      if (data is Map && data['status'] == "S100") {
        return data['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
