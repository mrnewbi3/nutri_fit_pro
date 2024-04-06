import 'package:flutter/material.dart';

class UserInformationProvider extends ChangeNotifier {
  late String _username;
  late String _email;
  late String _password;

  String get username => _username;
  String get email => _email;
  String get password => _password;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }
}
