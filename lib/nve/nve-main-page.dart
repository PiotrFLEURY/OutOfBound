import 'package:flutter/material.dart';

class NveMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: Center(child: new Text(
          "Hello World"
      )),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Start position")),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_back), title: Text("Actual position")),
        BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings")),
      ]),
    );
  }
}
