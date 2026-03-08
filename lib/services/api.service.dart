// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class IQService {
//   static const String baseUrl = "https://smartiq.ideacipher.com/index.php/API/";

//   /// categories ---------------------------------------------------------------

//   static Future<List<dynamic>> fetchCategories(
//     String categoryId,
//     String token,
//   ) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}getCategory",
//         data: {"module": categoryId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       print("Response: ${response.data}");

//       if (response.statusCode == 200 && response.data != null) {
//         dynamic data = response.data;

//         if (data is String) {
//           data = jsonDecode(data);
//         }

//         if (data is Map && data['status'] == "S100" && data['data'] != null) {
//           final List<dynamic> items = data['data'];
//           return items;
//         } else {}
//       }
//       return [];
//     } catch (e) {
//       if (kDebugMode) {
//         print('[IQService][fetchQuestion] exception: $e');
//       }
//       return [];
//     }
//   }

//   /// Levels
//   static Future<List<dynamic>> fetchLevels(
//     String categoryId,
//     String token,
//   ) async {
//     try {
//       final dio = Dio();
//       final response = await dio.post(
//         "${baseUrl}getLevel",
//         data: {"category_id": categoryId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       var data = response.data;
//       if (data is String) {
//         data = jsonDecode(data);
//       }

//       if (response.statusCode == 200 && data['status'] == "S100") {
//         final List<dynamic> items = data['data'];
//         return items;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   /// Question -----------------------------------------------------------------

//   static Future<dynamic> fetchQuestion(
//     String categoryId,
//     String levelId,
//     String token,
//   ) async {
//     try {
//       final dio = Dio();
//       final response = await dio.post(
//         "${baseUrl}getQuestion",
//         data: {"cat_id": categoryId, "level_id": levelId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       var data = response.data;
//       if (data is String) {
//         data = jsonDecode(data);
//       }
//       if (response.statusCode == 200 && data['status'] == "S100") {
//         final dynamic payload = data['data'];
//         return payload;
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   /// Leader bord data ---------------------------------------------------------

//   static Future<Map<String, dynamic>> fetchLeaderboardData(
//     String userId,
//     String token,
//   ) async {
//     try {
//       final dio = Dio();
//       final response = await dio.post(
//         "${baseUrl}getLeaderboard",
//         data: {"user_id": userId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );
//       dynamic data = response.data;
//       if (data is String) {
//         data = jsonDecode(data);
//       }
//       if (data is Map && data["status"] == "S100") {
//         return Map<String, dynamic>.from(data["data"]);
//       }
//       return {};
//     } catch (e) {
//       return {};
//     }
//   }

//   /// register screen data------------------------------------------------------

//   static Future<Map<String, dynamic>> registerUser({
//     required String name,
//     required String phone,
//     required String coupon,
//   }) async {
//     try {
//       final dio = Dio();

//       final Map<String, dynamic> requestData = {
//         "name": name,
//         "phone": phone,
//         "coupon_code": coupon,
//       };

//       final response = await dio.post(
//         "${baseUrl}register",
//         data: requestData,
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );

//       dynamic data = response.data;

//       if (data is String) {
//         data = jsonDecode(data);
//       }

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       print("Register API Error: $e");
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// Login screen data---------------------------------------------------------

//   static Future<Map<String, dynamic>> loginUser({required String phone}) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}login",
//         data: {"phone": phone},
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );

//       dynamic data = response.data;
//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       if (kDebugMode) {
//         print("Login API Error: $e");
//       }
//       return {"success": false, "message": "Network error: $e"};
//     }
//   }

//   /// profile screen------------------------------------------------------------

//   static Future<Map<String, dynamic>> getProfile({
//     required String userId,
//     required String token,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}profile",
//         data: {"user_id": userId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// Deposit Bank Slip Upload--------------------------------------------------

//   static Future<Map<String, dynamic>> uploadBankSlip({
//     required String userId,
//     required String token,
//     required String amount,
//     required String premiumDays,
//     required String note,
//     required String filePath,
//   }) async {
//     try {
//       final dio = Dio();

//       String fileName = filePath.split('/').last;

//       final formData = FormData();

//       formData.fields.addAll([
//         const MapEntry("payment_method", "bank_transfer"),
//         MapEntry("amount", amount),
//         MapEntry("premium_days", premiumDays),
//         MapEntry("notes", note),
//         MapEntry("user_id", userId),
//       ]);

//       formData.files.add(
//         MapEntry(
//           "bank_slip",
//           await MultipartFile.fromFile(filePath, filename: fileName),
//         ),
//       );

//       print("Uploading bank slip: $fileName from $filePath");

//       final response = await dio.post(
//         "${baseUrl}createPayment",
//         data: formData,
//         options: Options(headers: {"token": token}),
//       );

//       dynamic data = response.data;

//       if (data is String) {
//         data = jsonDecode(data);
//       }

//       if (data is Map && data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       } else {
//         return {"success": false, "message": data["data"] ?? "Upload failed"};
//       }
//     } catch (e) {
//       return {"success": false, "message": e.toString()};
//     }
//   }

//   /// check checkPremiumStatus--------------------------------------------------

//   static Future<Map<String, dynamic>> getPremiumStatus({
//     required String userId,
//     required String token,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}checkPremiumStatus",
//         data: {"user_id": userId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// check Status check--------------------------------------------------------

//   static Future<Map<String, dynamic>> getPayment({
//     required String userId,
//     required String token,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}getPayment",
//         data: {"user_id": userId},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// card payment--------------------------------------------------------------

//   static Future<Map<String, dynamic>> getCardPayment({
//     required String userId,
//     required String token,
//     required String paymentMethod,
//     required String amount,
//     required String premiumDays,
//     required String transactionId,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}createPayment",
//         data: {
//           "user_id": int.tryParse(userId) ?? userId,
//           "payment_method": paymentMethod,
//           "amount": double.tryParse(amount) ?? amount,
//           "premium_days": int.tryParse(premiumDays) ?? premiumDays,
//           "transaction_id": transactionId,
//         },
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// Add user points-----------------------------------------------------------

//   static Future<Map<String, dynamic>> getUserPoints({
//     required String userId,
//     required String token,
//     required String point,
//     required String type,
//   }) async {
//     try {
//       final dio = Dio();

//       final requestData = {
//         "user_id": int.parse(userId),
//         "point": int.parse(point),
//         "type": int.parse(type),
//       };

//       final response = await dio.post(
//         "${baseUrl}updateUserPoint",
//         data: requestData,
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) {
//         data = jsonDecode(data);
//       }

//       return data;
//     } catch (e) {
//       return {
//         "status": "E500",
//         "data": {"message": "Network error: $e"},
//       };
//     }
//   }

//   /// coupon code

//   static Future<Map<String, dynamic>> getCouponCode({
//     required String couponCode,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}validateCoupon",
//         data: {"coupon_code": couponCode},
//         options: Options(headers: {"Content-Type": "application/json"}),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }

//   /// report Question

//   static Future<Map<String, dynamic>> reportQuestion({
//     required String questionId,
//     required String reason,
//     required String token,
//   }) async {
//     try {
//       final dio = Dio();

//       final response = await dio.post(
//         "${baseUrl}reportQuestion",
//         data: {"question_id": questionId, "reason": reason},
//         options: Options(
//           headers: {"Content-Type": "application/json", "token": token},
//         ),
//       );

//       dynamic data = response.data;

//       if (data is String) data = jsonDecode(data);

//       if (data["status"] == "S100") {
//         return {"success": true, "data": data["data"]};
//       }

//       return {"success": false, "message": data["data"]};
//     } catch (e) {
//       return {"success": false, "message": "Network error"};
//     }
//   }
// }
