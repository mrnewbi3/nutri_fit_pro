import 'package:flutter/material.dart';

class UsernameProvider with ChangeNotifier {
  late String _username ='Username';
  String get username => _username;

  late String _bmiResult = 'BMI';
  String get bmiResult => _bmiResult;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setBMIResult(String bmiResult) {
    _bmiResult = bmiResult;
    notifyListeners();
  }
}
