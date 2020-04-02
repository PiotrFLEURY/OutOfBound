import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

Location location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

class NveMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
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
  double _startingLongitude;
  double _startingLatitude;

  void setPosition(double longitude, double latitude) {
    _startingLongitude = longitude;
    _startingLatitude = latitude;
  }

  double getLongitude() {
    return _startingLongitude;
  }

  double getLatitude() {
    return _startingLatitude;
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  FirstScreen createState() => FirstScreen();
}

class FirstScreen extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final List<Widget> _children = [BluePage(), MyStatefulRedPage(), GreenPage()];

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
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Start position")),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), title: Text("Actual position")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings")),
        ]),
    );
  }
}

class BluePage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: 
          Text.rich(TextSpan(children: <TextSpan>[
            TextSpan(text: Provider.of<Position>(ctxt, listen: false).getLongitude().toString()),
            TextSpan(text: " / "),
            TextSpan(text: Provider.of<Position>(ctxt, listen: false).getLatitude().toString())
          ])),
        )
    );
  }
}

class MyStatefulRedPage extends StatefulWidget {
  MyStatefulRedPage({Key key}) : super(key: key);

  @override
  RedPage createState() => RedPage();
}

class RedPage extends State<MyStatefulRedPage> {
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
        body:
        Column(
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
                  Provider.of<Position>(context, listen: false).setPosition(_locationData.longitude, _locationData.latitude);
                },
                child: Text("Make as start"),
              )
            )
        ],)
      );
    } else {
      return new Scaffold(
        backgroundColor: Colors.red,
      );
    }
  }
}

class GreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      backgroundColor: Colors.green,
      body: Center(child: new Text(
          "Green Page"
      ))
    );
  }
}
