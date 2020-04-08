import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  String  _boundary;

  set boundary(String value){
  _boundary = value;
  notifyListeners();
}

  get boundary => _boundary;

}