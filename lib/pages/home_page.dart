import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'OutOfBound Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('OutOfBound Application'),
          ),
          body: Center(
            child: Text('Hello World'),
          ),
      ),
      );
  }
}