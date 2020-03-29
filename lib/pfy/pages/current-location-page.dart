import 'package:OutOfBounds/pfy/LocationProvider.dart';
import 'package:OutOfBounds/pfy/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActualLocationPage extends StatefulWidget {
  @override
  _ActualLocationPageState createState() => _ActualLocationPageState();
}

class _ActualLocationPageState extends State<ActualLocationPage> {
  bool loading;

  @override
  void initState() {
    super.initState();

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 96.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                var currentLocationAddress =
                    locationProvider.currentLocationAddress;

                if (currentLocationAddress == null) {
                  return buildLoading();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    "Currently at $currentLocationAddress",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                RaisedButton(
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    locationProvider.makeAsStart();
                                  },
                                  child: Text(
                                    "Make as start",
                                    key: Key('makeAsStartText'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Builder(builder: (context) {
                              var distanceFromStart =
                                  locationProvider.distanceFromStart;
                              if (loading) {
                                loading = false;
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (distanceFromStart == null) {
                                return Container();
                              } else {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "$distanceFromStart",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange),
                                    ),
                                    Text(
                                      "meters from starting point",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Center buildLoading() {
    return Center(
      child: Text(
        "Updating location...",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CURRENT_LOCATION_PRIMARY_TEXT_COLOR,
        ),
      ),
    );
  }
}
