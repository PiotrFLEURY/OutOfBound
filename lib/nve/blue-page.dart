import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'position-service.dart';
import 'nve-main-page.dart';

LocationData _locationData;

class MyStatefulBluePage extends StatefulWidget {
  MyStatefulBluePage({Key key}) : super(key: key);

  @override
  BluePage createState() => BluePage();
}

class BluePage extends State<MyStatefulBluePage> {
  double _distance = 0;

  Future<void> getDistance() async {
    _locationData = await location.getLocation();
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

  @override
  void initState() {
    getDistance().then((result) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    if (positionProvider().latitude != null &&
        positionProvider().longitude != null &&
        positionProvider().addresse != null) {
      return new Scaffold(
        backgroundColor: Colors.blue,
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
                        left: 35,
                        width: 350,
                        child: Text(Provider.of<PositionService>(context, listen: false).addresse, style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),),
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
                        left: 140,
                        child: 
                          Text("meters from this point", style: TextStyle(
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
        backgroundColor: Colors.blue,
      );
    }
  }

  PositionService positionProvider() => Provider.of<PositionService>(context, listen: false);
}