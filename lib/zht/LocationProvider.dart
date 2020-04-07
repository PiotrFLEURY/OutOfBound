import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  LocationData _currentLocation;
  LocationData _startingPosition;
  String  _value;

  /*Send MAJ*/
  set starting(LocationData value) {
    _startingPosition = value;
    notifyListeners();
  }

  set current(LocationData value) {
    _currentLocation = value;
    notifyListeners();
  }

set meters(String value){
  _value = value;
  notifyListeners();
}

  /*Save data*/
  get current => _currentLocation;
  get starting => _startingPosition;

  get meters => _value;

}
