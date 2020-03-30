import 'package:flutter/material.dart';

class ZhtMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<ZhtMainPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OutOfBound Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('OutOfBound Application'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Start Position'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Actual Position'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Setting'),
            ),
          ],
        ),
      ),
    );
  }
}
