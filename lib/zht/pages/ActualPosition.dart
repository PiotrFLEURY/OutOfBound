import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();

    initLocation();
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
    });
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
                "Actually at $distanceInMeters meters from the starting point."),
            isUserOutOfBouds(_providerSetting, _provider),
          ],
        )),
      );
    });
  }
}
