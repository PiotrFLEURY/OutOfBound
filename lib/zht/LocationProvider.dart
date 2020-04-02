

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {

  LocationData _currentLocation;  
  LocationData _startingPosition;

  /*Send MAJ*/
  set starting(value) {
    _startingPosition = value;
    notifyListeners();
  } 

  set current( LocationData value) {
    _currentLocation = value;
    notifyListeners();
  }
  /*Save data*/
  get current => _currentLocation;
  get starting => _startingPosition;
}