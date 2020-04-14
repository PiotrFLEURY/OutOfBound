import 'package:OutOfBounds/zht/LocationProvider.dart';
import 'package:OutOfBounds/zht/SettingProvider.dart';
import 'package:flutter/material.dart';
import 'package:OutOfBounds/zht/pages/StartPositionPage.dart';
import 'package:OutOfBounds/zht/pages/ActualPosition.dart';
import 'package:OutOfBounds/zht/pages/SettingsPage.dart';
import 'package:provider/provider.dart';

class ZhtMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<ZhtMainPage> {
  int whoSelected = 0;
  final itemsChoice = [
    StartPosition(),
    ActualPosition(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingProvider(),
        )
      ],
      child: new Scaffold(
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
          )),
    );
  }
}
