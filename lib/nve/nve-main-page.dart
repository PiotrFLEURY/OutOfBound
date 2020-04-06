import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

Location location = new Location();
Geolocator geo = new Geolocator();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

class NveMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Position()),
      ],
      child: Consumer<Position>(
        builder: (context, position, _) {
          return new MaterialApp(
            home: MyStatefulWidget(),
          );
        },
      ),
    );
  }
}

class Position with ChangeNotifier {
  int _boundary;
  double _startingLongitude;
  double _startingLatitude;

  set longitude(double longitude) {
    _startingLongitude = longitude;
  }

  set latitude(double latitude) {
    _startingLatitude = latitude;
  }

  set boundary(int boundary) {
    _boundary = boundary;
  }

  double get longitude {
    return _startingLongitude;
  }

  double get latitude {
    return _startingLatitude;
  }

  int get boundary {
    return _boundary;
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    MyStatefulBluePage(),
    MyStatefulRedPage(),
    MyStatefulGreenPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Start position")),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_back), title: Text("Actual position")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("Settings")),
          ]),
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
    if (Provider.of<Position>(context, listen: false).latitude != null &&
        Provider.of<Position>(context, listen: false).longitude != null) {
      _distance = await geo.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          Provider.of<Position>(context, listen: false).latitude,
          Provider.of<Position>(context, listen: false).longitude);
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
    if (Provider.of<Position>(context, listen: false).latitude != null &&
        Provider.of<Position>(context, listen: false).longitude != null) {
      return new Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Provider.of<Position>(ctxt, listen: false)
                            .longitude
                            .toString()),
                    TextSpan(text: " / "),
                    TextSpan(
                        text: Provider.of<Position>(ctxt, listen: false)
                            .latitude
                            .toString())
                  ])),
                ),
                Center(
                  child: Text.rich(TextSpan(children: <TextSpan>[
                    TextSpan(text: "actually at "),
                    TextSpan(text: _distance.toInt().toString()),
                    TextSpan(text: " meters from this point")
                  ])),
                )
              ]));
    } else {
      return new Scaffold(
        backgroundColor: Colors.blue,
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
    if (Provider.of<Position>(context, listen: false).latitude != null &&
        Provider.of<Position>(context, listen: false).longitude != null) {
      _distance = await geo.distanceBetween(
          _locationData.latitude,
          _locationData.longitude,
          Provider.of<Position>(context, listen: false).latitude,
          Provider.of<Position>(context, listen: false).longitude);
    }
  }

  @override
  void initState() {
    askPermission().then((result) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    if (_locationData != null) {
      return new Scaffold(
          backgroundColor: Colors.red,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text.rich(TextSpan(children: <TextSpan>[
                  TextSpan(text: _locationData.longitude.toString()),
                  TextSpan(text: " / "),
                  TextSpan(text: _locationData.latitude.toString())
                ])),
              ),
              Center(
                  child: RaisedButton(
                onPressed: () {
                  Provider.of<Position>(context, listen: false).longitude =
                      _locationData.longitude;
                  Provider.of<Position>(context, listen: false).latitude =
                      _locationData.latitude;
                },
                child: Text("Make as start"),
              )),
              Center(
                child: Text.rich(TextSpan(children: <TextSpan>[
                  TextSpan(text: "actually at "),
                  TextSpan(text: _distance.toInt().toString()),
                  TextSpan(text: " meters from the starting point")
                ])),
              ),
            ],
          ));
    } else {
      return new Scaffold(
        backgroundColor: Colors.red,
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

  void _handleSubmitted(String finalinput) {
    setState(() {
      Provider.of<Position>(context, listen: false).boundary = int.parse(finalinput);
      debugPrint(Provider.of<Position>(context, listen: false).boundary.toString());
    });
  }

  _setBoundary() {
    TextField _textField = new TextField(
      controller: _controller,
      onSubmitted: _handleSubmitted,
      keyboardType: TextInputType.number,
    );

    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(
        focusNode: _textNode,
        child: _textField);
  }

  @override
  Widget build(BuildContext ctxt) {
      return new Scaffold(
          backgroundColor: Colors.green,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Boundary :"),
                ),
                Center(
                  child: _setBoundary(),
                ),
              ]
          )
      );
  }
}
