import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ActualPosition extends StatefulWidget {
  @override
  ActualPositionState createState() => ActualPositionState();
}

class ActualPositionState extends State<ActualPosition> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Geolocator geolocator = new Geolocator();
  double distanceInMeters;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var test = false;

  @override
  void initState() {
    super.initState();
    initLocation();
    initNotification();
  }

  initNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationAndroid = AndroidInitializationSettings('app_icon');
    var initializationIOS = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(initializationAndroid, initializationIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void setInitialLocation() async {
    Provider.of<LocationProvider>(context).current =
        await location.getLocation();
  }

  void initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setInitialLocation();
  }

  getLatandLng() {
    if (Provider.of<LocationProvider>(context).current != null)
      return Text(
          "LATITUDE: ${Provider.of<LocationProvider>(context).current.latitude}, LONGITUDE: ${Provider.of<LocationProvider>(context).current.longitude}");
    else
      return Text("You don't have a start position !");
  }

  Future<double> distanceBetween2(
      LocationData current, LocationData start) async {
    distanceInMeters = await geolocator.distanceBetween(
        current.latitude, current.longitude, start.latitude, start.longitude);
    return distanceInMeters;
  }

  void updateDistance(LocationProvider provider) async {
    var distance;
    if (provider.current != null && provider.starting != null) {
      distance = await distanceBetween2(provider.current, provider.starting);
      setState(() {
        distanceInMeters = distance;
        provider.distance = distanceInMeters;
      });
    }
  }

  updateLocationBoundary(
      SettingProvider _settingProvider, LocationProvider _locationProvider) {
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationProvider.current = currentLocation;
      allNotifications(_settingProvider, _locationProvider);
    });
    location.changeSettings(interval: 5000, distanceFilter: 1);
  }

  allNotifications(
      SettingProvider _settingProvider, LocationProvider _locationProvider) {
    var boundary = double.parse(_settingProvider.boundary);
    var distance = _locationProvider.distance;

    if (Provider.of<SettingProvider>(context).isEnableLocation == true) {
      showAlertsNotification();
    }

    if (_locationProvider.haveDistance == true &&
        distance > boundary &&
        (test == false)) {
      showIsOutOfBoundsNotification(
          _settingProvider, _locationProvider, distance);
      test = true;
    } else if (_locationProvider.haveDistance == true &&
        (distance <= boundary) &&
        (test == true)) {
      showItsOKNotification(_settingProvider, _locationProvider);
      test = false;
    }
  }

  isUserOutOfBouds(SettingProvider _provider, LocationProvider _provid) {
    if (Provider.of<SettingProvider>(context).isEnableLocation == true) {
      var boundary = double.parse(_provider.boundary);
      var distance = _provid.distance;
      if ((_provid.haveDistance == true) && (distance > boundary))
        return Text("You are out of bounds");
      else
        return Text("OK");
    } else
      return Text("You must enable alerts.");
  }

  showAlertsNotification() async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        autoCancel: false);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin
        .show(0, 'OutOfBounds', 'Alerts enabled', platform, payload: 'item x');
    test = true;
  }

  showIsOutOfBoundsNotification(SettingProvider _provider,
      LocationProvider _provid, double distance) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        autoCancel: true);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        1,
        'OutOfBounds',
        "Alert ! You are ${distance} meter too far from your starting point. ",
        platform,
        payload: 'item x');
  }

  showItsOKNotification(
      SettingProvider _provider, LocationProvider _provid) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        autoCancel: true);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.show(
        1, 'OutOfBounds', "Ok, all is all right now.", platform,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, SettingProvider>(
        builder: (context, _provider, _providerSetting, _) {
      updateDistance(_provider);
      updateLocationBoundary(_providerSetting, _provider);

      return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getLatandLng(),
            RaisedButton(
                child: Text("Make as start"),
                onPressed: () {
                  _provider.starting = _provider.current;
                  _provider.haveDistance = true;
                }),
            Text(
                "Actually at ${_provider.distance} meters from the starting point."),
            isUserOutOfBouds(_providerSetting, _provider),
          ],
        )),
      );
    });
  }
}
