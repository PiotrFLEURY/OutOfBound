import 'package:flutter/material.dart';
import 'package:location/location.dart';

Location location = new Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

class NveMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: MyStatefulWidget(),
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
      body: Center(child: new Text(
          "Blue Page"
      ))
    );
  }
}

class MyStatefulRedPage extends StatefulWidget {
  MyStatefulRedPage({Key key}) : super(key: key);

  @override
  RedPage createState() => RedPage();
}

class RedPage extends State<MyStatefulRedPage> {
  bool _result;

  Future<bool> askPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    _locationData = await location.getLocation();
    return true;
  }

  @override
  void initState() {
    askPermission().then((result) {
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    if (_result == true) {
      return new Scaffold(
        backgroundColor: Colors.red,
        body:
            Center(
              child: Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(text: _locationData.longitude.toString()),
                TextSpan(text: " / "),
                TextSpan(text: _locationData.latitude.toString())
              ]))
            ),
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
