import 'package:flutter/material.dart';

// user_provider.dart
class UserProvider extends ChangeNotifier {
  String _id = '';

  String get id => _id;

  void setUserId(String id) {
    _id = id;
    notifyListeners();
  }

  String getUserId() {
    return _id;
  }
}
