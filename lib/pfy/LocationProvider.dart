import 'package:OutOfBounds/pfy/services/NotificationService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

const INTERVAL_MILLIS = 5000;
const MIN_DISTANCE_METER = 10;

class LocationProvider with ChangeNotifier {
  NotificationService notificationService =
      GetIt.instance.get<NotificationService>();
  Geolocator geolocator = GetIt.instance.get<Geolocator>();

  LocationData _startingLocationData;
  LocationData _currentLocationData;
  double _distanceFromStart;

  String _startingLocationAddress;
  String _currentLocationAddress;

  get startingLocationAddress => _startingLocationAddress;

  get currentLocationAddress => _currentLocationAddress;

  get startingLocationData => _startingLocationData;

  set currentLocationData(value) {
    _currentLocationData = value;
    notifyListeners();
  }

  get currentLocationData => _currentLocationData;

  Future<void> onLocationChanged(LocationData locationData) async {
    _currentLocationData = locationData;
    _currentLocationAddress =
        await getAddressFromLocation(_currentLocationData);

    if (_startingLocationData != null) {
      _distanceFromStart = await geolocator.distanceBetween(
        _startingLocationData.latitude,
        _startingLocationData.longitude,
        locationData.latitude,
        locationData.longitude,
      );
    }

    notificationService.updateAlertNotification(_distanceFromStart);

    notifyListeners();
  }

  get distanceFromStart => _distanceFromStart?.floor();

  makeAsStart() async {
    _startingLocationData = _currentLocationData;
    _startingLocationAddress =
        await getAddressFromLocation(_startingLocationData);

    notifyListeners();
  }

  Future<String> getAddressFromLocation(LocationData data) async {
    try {
      List<Placemark> placemarks = await geolocator.placemarkFromCoordinates(
          data.latitude, data.longitude);
      Placemark placemark = placemarks.first;

      return "${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.postalCode} ${placemark.locality} ${placemark.country}";
    } catch (e) {
      debugPrint("error occured from geolocator $e");
    }
    return "UNKNWON ERROR";
  }
}
