import 'package:OutOfBounds/pfy/LocationProvider.dart';
import 'package:OutOfBounds/pfy/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartingLocationPage extends StatefulWidget {
  @override
  _StartingLocationPageState createState() => _StartingLocationPageState();
}

class _StartingLocationPageState extends State<StartingLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        var startingLocationAddress = locationProvider.startingLocationAddress;
        return Center(
          child: Builder(
            builder: (context) {
              if (startingLocationAddress == null) {
                return buildEmptyScreen();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: STARTING_LOCATION_BACKGROUND_COLOR_LIGHT,
                  child: Material(
                    borderRadius: BorderRadius.circular(4.0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            startingLocationAddress,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          buildDistanceText(context),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Text buildEmptyScreen() {
    return Text(
      "No starting position registered",
      key: Key('noStartLocationText'),
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: STARTING_LOCATION_PRIMARY_DARK_TEXT_COLOR,
      ),
    );
  }

  Widget buildDistanceText(context) {
    var distanceFromStart =
        Provider.of<LocationProvider>(context).distanceFromStart;
    if (distanceFromStart == null) {
      return Container();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            distanceFromStart.toString(),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Text(
            "meters from this point",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }
}
