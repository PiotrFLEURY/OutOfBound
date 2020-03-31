import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ActualPosition extends StatefulWidget {
  @override
  ActualPositionState createState() => ActualPositionState();
}

class ActualPositionState extends State<ActualPosition>{

  @override
  void initState(){
    super.initState();
    requestPermission();
  }

  void requestPermission() async{

    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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

  }

  @override
  Widget build(BuildContext context){
     return new MaterialApp(
         home: new Scaffold(
        backgroundColor: Colors.blue,
        
      ),
    
    );
  }

}
