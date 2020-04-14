import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  LocationData _currentLocation;
  LocationData _startingPosition;
  double _distance;
  bool _haveDistance=false;


  /*Send MAJ*/
  set starting(LocationData value) {
    _startingPosition = value;
    notifyListeners();
  }

  set current(LocationData value) {
    _currentLocation = value;
    notifyListeners();
  }

    set distance(double value) {
    _distance = value;
    notifyListeners();
  }

      set haveDistance(bool value) {
    _haveDistance = value;
    notifyListeners();
  }

  /*Save data*/
  get current => _currentLocation;
  get starting => _startingPosition;
get distance => _distance;
get haveDistance => _haveDistance;


}
