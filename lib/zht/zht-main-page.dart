import 'package:flutter/material.dart';

class ZhtMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
    throw UnimplementedError();
  }
}
