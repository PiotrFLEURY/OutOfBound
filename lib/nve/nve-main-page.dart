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
  int _selectedIndex = 0;
  final List<Widget> _children = [BluePage(), RedPage(), GreenPage()];

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
