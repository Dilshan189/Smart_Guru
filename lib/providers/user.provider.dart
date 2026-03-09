import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  String? _token;
  String? _name;

  String? get userId => _userId;
  String? get token => _token;
  String? get name => _name;

  void setUser(String id, String token, String name) {
    _userId = id;
    _token = token;
    _name = name;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _token = null;
    _name = null;
    notifyListeners();
  }
}
