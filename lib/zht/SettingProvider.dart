import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  String  _value;

  set meters(String value){
  _value = value;
  notifyListeners();
}

  get meters => _value;

}