import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:OutOfBounds/zht/pages/ActualPosition.dart';

class StartPositionPage extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return Consumer<LocationProvider>(
        builder: (context, _start, _) {
          LocationData start = _start.starting;
          if (start != null) {
            return Scaffold(
               backgroundColor: Colors.blue,
             body: Center(child:  Text("LATITUDE: ${start.latitude}, LONGITUDE: ${start.longitude}"))
            );
          }
          else {
            return Scaffold(
               backgroundColor: Colors.blue,
              body: Center(child:Text("You don't have a start position !"),)
            );
          }
        }  
    );
  }
  
}