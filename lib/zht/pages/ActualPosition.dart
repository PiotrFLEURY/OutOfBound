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
    
     Provider.of<LocationProvider>(context).current = location.getLocation();
  }

  getLatandLng(){
    if (Provider.of<LocationProvider>(context).current != null)   
      return  Text("LATITUDE: ${Provider.of<LocationProvider>(context).current.latitude}, LONGITUDE: ${Provider.of<LocationProvider>(context).current.longitude}");
    else
      return Text("You don't have a start position !");
  }

 @override
  Widget build(BuildContext context){

     
    return Consumer<LocationProvider>(
        builder: (context, _actual, _) {
            return Scaffold(
            backgroundColor: Colors.red,          
            body:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children :[
                getLatandLng(),               
                RaisedButton(
                  child: Text("Make as start"),
                    onPressed: () {
                      _actual.starting = _actual.current;
                   }
                  ),
                 
                 ]
                )
              ),   
            );
         }
    );
  }
}                      
