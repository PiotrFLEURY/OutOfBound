import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SettingProvider with ChangeNotifier{

  String  _boundaryInMeters="0";
  bool _isEnable=false;

  set boundary(String value){
    _boundaryInMeters = value;
    notifyListeners();
  }

  set isEnableLocation (bool value){
    _isEnable = value;
    notifyListeners();
  }


  get boundary => _boundaryInMeters;
  get isEnableLocation => _isEnable;

}