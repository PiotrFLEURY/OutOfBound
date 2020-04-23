import 'package:OutOfBounds/nve/notification-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'position-service.dart';
import 'settings-service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Location location = new Location();
SettingsService settings = new SettingsService();
Geolocator geo = new Geolocator();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationService notificationService = new NotificationService();

class NveMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PositionService()),
      ],
      child: Consumer<PositionService>(
        builder: (context, position, _) {
          return new MaterialApp(
            home: MyStatefulWidget(),
          );
        },
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const BLUE_PAGE_INDEX = 0;
  static const RED_PAGE_INDEX = 1;
  static const GREEN_PAGE_INDEX = 2;
  Alignment _alignment = Alignment.bottomLeft;
  bool isUserOutOfBounds = false;
  final List<Widget> _children = [
    MyStatefulBluePage(),
    MyStatefulRedPage(),
    MyStatefulGreenPage()
  ];

  Future<void> isOutOfBounds() async {
    double distance = await geo.distanceBetween(
        _locationData.latitude,
        _locationData.longitude,
        Provider.of<PositionService>(context, listen: false).latitude,
        Provider.of<PositionService>(context, listen: false).longitude);
    if (distance > settings.boundary) {
      debugPrint("The user goes out of bounds");
      notificationService.showOutOfBoundsNotification(distance.toString());
      isUserOutOfBounds = true;
    } else if (isUserOutOfBounds == true && distance <= settings.boundary) {
      notificationService.showBackInBoundsNotification();
      notificationService.cancelNotification(
          NotificationService.OUT_OF_BOUNDS_NOTIFICATION_ID);
      isUserOutOfBounds = false;
    }
  }

  @override
  void initState() {
    location.onLocationChanged.listen((_locationData) {
      setState(() {
        if (settings.enableAlerts == true &&
            settings.boundary != null &&
            Provider.of<PositionService>(context, listen: false).latitude !=
                null &&
            Provider.of<PositionService>(context, listen: false).longitude !=
                null) {
          isOutOfBounds();
        }
      });
    });
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload :' + payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
            ));
  }

  _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _alignment = Alignment.bottomLeft;
          break;
        case 1:
          _alignment = Alignment.bottomCenter;
          break;
        case 2:
          _alignment = Alignment.bottomRight;
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          height: kBottomNavigationBarHeight,
          child: Stack(children: <Widget>[
            AnimatedAlign(
              duration: Duration(milliseconds: 500),
              alignment: _alignment,
              child: Container(
                width: 120,
                height: kBottomNavigationBarHeight,
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: FlatButton.icon(
                    icon: new Image.asset(
                      'assets/images/mansion.png',
                      width: 20,
                    ),
                    onPressed: () => _onItemTapped(BLUE_PAGE_INDEX),
                    label: Text(
                      "Starting position",
                      style: TextStyle(fontSize: 8),
                    ),
                  )),
                  Expanded(
                      child: FlatButton.icon(
                          icon: new Image.asset(
                            'assets/images/map.png',
                            width: 20,
                          ),
                          onPressed: () => _onItemTapped(RED_PAGE_INDEX),
                          label: Text(
                            "Current position",
                            style: TextStyle(fontSize: 8),
                          ))),
                  Expanded(
                      child: FlatButton.icon(
                          icon: new Image.asset(
                            'assets/images/gear.png',
                            width: 20,
                          ),
                          onPressed: () => _onItemTapped(GREEN_PAGE_INDEX),
                          label: Text(
                            "Settings",
                            style: TextStyle(fontSize: 8),
                          ))),
                ])
          ])),
    );
  }
}

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
    if (Provider.of<PositionService>(context, listen: false).latitude != null &&
        Provider.of<PositionService>(context, listen: false).longitude != null &&
        Provider.of<PositionService>(context, listen: false).addresse != null) {
      return new Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: MyCustomClipper(),
              child: new Image.asset("assets/images/googlemap.png"),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.42,
              child: ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset(
                "assets/images/mansion.png",
                width: 50,
              ),
            ),
            Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration(seconds: 1),
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
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: MyCustomClipper(),
              child: new Image.asset("assets/images/googlemap.png"),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.42,
              child: ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset(
                "assets/images/mansion.png",
                width: 50,
              ),
            ),
          ],
        ),
      );
    }
  }
}

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
    final _coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses = await Geocoder.local.findAddressesFromCoordinates(_coordinates);
    var _first = _addresses.first;
    return _first.addressLine;
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
            ClipPath(
              clipper: MyCustomClipper(),
              child: new Image.asset("assets/images/googlemap.png"),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.42,
              child: ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset(
                "assets/images/map.png",
                width: 50,
              ),
            ),
            Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration(seconds: 1),
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
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: MyCustomClipper(),
              child: new Image.asset("assets/images/googlemap.png"),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.19,
              left: MediaQuery.of(context).size.width * 0.42,
              child: ClipOval(
                child: Container(
                  width: 75,
                  height: 75,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.45,
              child: Image.asset(
                "assets/images/map.png",
                width: 50,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class MyStatefulGreenPage extends StatefulWidget {
  MyStatefulGreenPage({Key key}) : super(key: key);

  @override
  GreenPage createState() => GreenPage();
}

class GreenPage extends State<MyStatefulGreenPage> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleSubmitted(String finalinput) {
    setState(() {
      settings.boundary = int.parse(finalinput);
      debugPrint(settings.boundary.toString());
    });
  }

  _setBoundary() {
    TextField _textField = new TextField(
      textAlign: TextAlign.end,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
          fillColor: Colors.grey,
          labelText: "Boundary",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          )),
      controller: _controller,
      onSubmitted: _handleSubmitted,
      keyboardType: TextInputType.number,
    );

    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(focusNode: _textNode, child: _textField);
  }

  void _setAlerts(bool value) {
    setState(() {
      settings.enableAlerts = value;
      if (settings.enableAlerts == true) {
        notificationService.showAlertNotification();
      } else {
        notificationService
            .cancelNotification(NotificationService.ENABLE_NOTIFICATION_ID);
      }
      debugPrint(settings.enableAlerts.toString());
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(),
            child: new Image.asset("assets/images/googlemap.png"),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.19,
            left: MediaQuery.of(context).size.width * 0.42,
            child: ClipOval(
              child: Container(
                width: 75,
                height: 75,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.205,
            left: MediaQuery.of(context).size.width * 0.45,
            child: Image.asset(
              "assets/images/gear.png",
              width: 50,
            ),
          ),
          Material(
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration(seconds: 1),
              color: Colors.transparent,
              child: Center(
                  child: Container(
                      height: 200,
                      width: 400,
                      child: Card(
                        child: Stack(children: <Widget>[
                          Positioned(
                            width: 350,
                            top: 20,
                            left: 20,
                            child: _setBoundary(),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 100,
                            child: Text(
                              "Enable alerts :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 35,
                            right: 100,
                            child: Checkbox(
                              value: settings.enableAlerts,
                              onChanged: (value) => _setAlerts(value),
                            ),
                          )
                        ]),
                      )))),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width / 1.8, size.height / 1.6, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
