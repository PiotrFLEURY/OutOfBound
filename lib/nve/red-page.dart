import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'position-service.dart';
import 'nve-main-page.dart';

LocationData _locationData;
bool _serviceEnabled;
PermissionStatus _permissionGranted;

class MyStatefulRedPage extends StatefulWidget {
  MyStatefulRedPage({Key key}) : super(key: key);

  @override
  RedPage createState() => RedPage();
}

class RedPage extends State<MyStatefulRedPage> {
  double _distance = 0;
  String _addresse = "";

  Future<void> askPermission() async {
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
    _addresse = await getAddress();
    if (Provider.of<PositionService>(context, listen: false).latitude != null &&
        Provider.of<PositionService>(context, listen: false).longitude !=
            null) {
      _distance = await geo.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          Provider.of<PositionService>(context, listen: false).latitude,
          Provider.of<PositionService>(context, listen: false).longitude);
    }
  }

  Future<String> getAddress() async {
    if (_locationData != null) {
      final _coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
      if (_coordinates != null) {
        var _addresses = await Geocoder.local.findAddressesFromCoordinates(_coordinates);
        var _first = _addresses.first;
        return _first.addressLine;
      }
      return "";     
    }
    return "";
  }

  @override
  void initState() {
    askPermission().then((result) {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    if (_locationData != null) {
      return new Scaffold(
        backgroundColor: Colors.red,
        body: Stack(
          children: <Widget>[
            Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: 200,
                  width: 400,
                  child: Card(
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 40,
                        left: 20,
                        width: 200,
                        child: Text("Currently at " + _addresse, style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      Positioned(
                        top: 30,
                        right: 20,
                        child: RaisedButton(
                          color: Colors.orange,
                          onPressed: () {
                            Provider.of<PositionService>(context, listen: false).longitude = _locationData.longitude;
                            Provider.of<PositionService>(context, listen: false).latitude = _locationData.latitude;
                            Provider.of<PositionService>(context, listen: false).addresse= _addresse;
                          },
                          child: Text("Make as start", style: TextStyle(
                            color: Colors.white,
                          ),),
                        )
                      ),
                      Positioned(
                        bottom: 40,
                        left: 175,
                        child:
                          Text(_distance.toInt().toString(), style: TextStyle(
                            color: Colors.orange,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 125,
                        child: 
                          Text("meters from starting point", style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey
                          ),),
                      )
                    ]),
                  )
                )
              )
            ),
          ],
        ),
      );
    } else {
      return new Scaffold(
        backgroundColor: Colors.red,
      );
    }
  }
}