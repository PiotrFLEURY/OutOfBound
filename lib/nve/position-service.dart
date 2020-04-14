import 'package:flutter/material.dart';

class PositionService with ChangeNotifier {
  double _startingLongitude;
  double _startingLatitude;

  set longitude(double longitude) {
    _startingLongitude = longitude;
    notifyListeners();
  }

  set latitude(double latitude) {
    _startingLatitude = latitude;
    notifyListeners();
  }

  double get longitude {
    return _startingLongitude;
  }

  double get latitude {
    return _startingLatitude;
  }
}
