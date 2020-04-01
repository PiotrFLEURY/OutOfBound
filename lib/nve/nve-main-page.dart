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
  final List<Widget> _children = [BluePage(), RedPage(), GreenPage()];

  Future<void> _onItemTapped(int index) async {
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

class RedPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
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
