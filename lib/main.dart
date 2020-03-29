import 'package:OutOfBounds/nve/nve-main-page.dart';
import 'package:OutOfBounds/pfy/pages/pfy-main-page.dart';
import 'package:OutOfBounds/pfy/pages/user-page.dart';
import 'package:OutOfBounds/pfy/services/NotificationService.dart';
import 'package:OutOfBounds/pfy/services/SettingsService.dart';
import 'package:OutOfBounds/zht/zht-main-page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<Geolocator>(Geolocator());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/nve': (context) => NveMainPage(),
        '/zht': (context) => ZhtMainPage(),
        '/pfy': (context) => PfyMainPage(),
        '/pfy/profile': (context) => UserPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
                onPressed: () => Navigator.of(context).pushNamed("/nve"),
                child: Text("nve")),
            RaisedButton(
                onPressed: () => Navigator.of(context).pushNamed("/zht"),
                child: Text("zht")),
            RaisedButton(
                key: Key('PfyMainBtn'),
                onPressed: () => Navigator.of(context).pushNamed("/pfy"),
                child: Text("pfy")),
          ],
        ),
      ),
    );
  }
}
