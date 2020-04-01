import 'package:flutter/material.dart';

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
  int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
    _selectedIndex = index;
      switch (index) {
        case 0:
        {
          Navigator.push(
            context, 
            new MaterialPageRoute(builder: (context) => new BluePage()),
          );
          break;
        }
        case 1:
        {
          Navigator.push(
            context, 
            new MaterialPageRoute(builder: (context) => new RedPage()),
          );
          break;
        }
        case 2:
        {
          Navigator.push(
            context, 
            new MaterialPageRoute(builder: (context) => new GreenPage()),
          );
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: Center(child: new Text(
          "Hello World"
      )),
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
      body: Center(child: new Text(
          "Red Page"
      ))
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
