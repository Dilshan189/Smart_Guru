import 'package:get_storage/get_storage.dart';

class SessionManager {
  static final GetStorage _box = GetStorage();

  // Keys
  static const String _keyUserId = 'user_id';
  static const String _keyToken = 'token';
  static const String _keyName = 'name';
  static const String _keyPhone = 'phone';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyIsPremium = 'is_premium';

  // Save Session
  static Future<void> saveSession({
    required int userId,
    required String token,
    String? name,
    String? phone,
    int? isPremium,
  }) async {
    await _box.write(_keyUserId, userId);
    await _box.write(_keyToken, token);
    await _box.write(_keyName, name);
    await _box.write(_keyPhone, phone);
    await _box.write(_keyIsPremium, isPremium);
    await _box.write(_keyIsLoggedIn, true);
  }

  // Getters
  static int? get userId => _box.read(_keyUserId);
  static String? get token => _box.read(_keyToken);
  static String? get name => _box.read(_keyName);
  static String? get phone => _box.read(_keyPhone);
  static bool get isLoggedIn => _box.read(_keyIsLoggedIn) ?? false;
  static int? get isPremium => _box.read(_keyIsPremium);

  // Clear Session
  static Future<void> logout() async {
    await _box.erase();
  }
}
