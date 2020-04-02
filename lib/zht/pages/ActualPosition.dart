import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:provider/provider.dart';

class ActualPosition extends StatefulWidget {
  @override
  ActualPositionState createState() => ActualPositionState();
}

class ActualPositionState extends State<ActualPosition>{

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  @override
  void initState(){
    super.initState();
    initLocation(); 
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
    
    _locationData = await location.getLocation();
    

  }

  getLatandLng(){
    if (_locationData != null)   
      return  Text("LATITUDE: ${_locationData.latitude}, LONGITUDE: ${_locationData.longitude}");
  }

 @override
  Widget build(BuildContext context){
    return Consumer<LocationProvider>(
        builder: (context, _actual, _) {
            return Scaffold(
            backgroundColor: Colors.red,
            body:Center(
              child: new RaisedButton(
                child: Text("Make as start"),
                    onPressed: () {
                      _actual.current=_locationData;
                      _actual.starting = _actual.current;
                   }
                  ),
            ),
            );
        }
            );
}
}