import 'package:flutter/material.dart';
import 'package:OutOfBounds/zht/pages/StartPositionPage.dart';
import 'package:OutOfBounds/zht/pages/ActualPosition.dart';
import 'package:OutOfBounds/zht/pages/SettingsPage.dart';

class ZhtMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<ZhtMainPage> {
  int whoSelected = 0;
  final itemsChoice = [
    StartPositionPage(),
    ActualPosition(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'OutOfBound Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('OutOfBound Application'),
        ),
        body: itemsChoice[whoSelected],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: whoSelected,
          onTap: (int index) {
            setState(() {
              whoSelected = index;
            });
          },
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
