import 'package:OutOfBounds/nve/notification-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'position-service.dart';
import 'settings-service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'blue-page.dart';
import 'red-page.dart';
import 'green-page.dart';

Location location = new Location();
SettingsService settings = new SettingsService();
Geolocator geo = new Geolocator();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationService notificationService = new NotificationService();
Image _image = Image.asset(
        "assets/images/mansion.png",
        width: 50,
      );

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
  PageController _pageViewController = PageController();

  Future<void> isOutOfBounds(LocationData _locationData) async {
    double _distance = await geo.distanceBetween(
        _locationData.latitude,
        _locationData.longitude,
        Provider.of<PositionService>(context, listen: false).latitude,
        Provider.of<PositionService>(context, listen: false).longitude);
    debugPrint(settings.boundary.toString());
    if (_distance > settings.boundary) {
      debugPrint("The user goes out of bounds");
      notificationService.showOutOfBoundsNotification(_distance.toString());
      isUserOutOfBounds = true;
    } else if (isUserOutOfBounds == true && _distance <= settings.boundary) {
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
          isOutOfBounds(_locationData);
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
        case BLUE_PAGE_INDEX:
          _alignment = Alignment.bottomLeft;
          _image = Image.asset(
            "assets/images/mansion.png",
            width: 50,
          );
          break;
        case RED_PAGE_INDEX:
          _alignment = Alignment.bottomCenter;
          _image = Image.asset(
            "assets/images/map.png",
            width: 50,
          );
          break;
        case GREEN_PAGE_INDEX:
          _alignment = Alignment.bottomRight;
          _image = Image.asset(
            "assets/images/gear.png",
            width: 50,
          );
          break;
      }
      _selectedIndex = index;
      animatePageChange();
    });
  }

  animatePageChange() async {
    await _pageViewController.animateToPage(
        _selectedIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.decelerate,
      );
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: Stack(children: <Widget>[
        PageView(
          controller: _pageViewController,
          scrollDirection: Axis.horizontal,
          children: _children,
        ),
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
          child: _image,
        ),
        ],
      ),
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
