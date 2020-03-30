//import 'package:OutOfBounds/nve/nve-main-page.dart';
//import 'package:OutOfBounds/zht/zht-main-page.dart';
import 'package:flutter/material.dart';
import './pages/home_page.dart';


void main(){
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}
/*
void main() {
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
          ],
        ),
      ),
    );
  }
}*/