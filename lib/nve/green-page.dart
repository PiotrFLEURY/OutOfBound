import 'package:OutOfBounds/nve/notification-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'nve-main-page.dart';

class MyStatefulGreenPage extends StatefulWidget {
  MyStatefulGreenPage({Key key}) : super(key: key);

  @override
  GreenPage createState() => GreenPage();
}

class GreenPage extends State<MyStatefulGreenPage> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();

  void _handleSubmitted(String finalinput) {
    setState(() {
      settings.boundary = int.parse(finalinput);
      debugPrint(settings.boundary.toString());
    });
  }

  _setBoundary() {
    TextField _textField = new TextField(
      textAlign: TextAlign.end,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          filled: true,
          fillColor: Colors.grey,
          labelText: "Boundary",
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          )),
      controller: _controller,
      onSubmitted: _handleSubmitted,
      keyboardType: TextInputType.number,
    );

    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(focusNode: _textNode, child: _textField);
  }

  void _setAlerts(bool value) {
    setState(() {
      settings.enableAlerts = value;
      if (settings.enableAlerts == true) {
        notificationService.showAlertNotification();
      } else {
        notificationService
            .cancelNotification(NotificationService.ENABLE_NOTIFICATION_ID);
      }
      debugPrint(settings.enableAlerts.toString());
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: <Widget>[
          Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: Center(
                  child: Container(
                      height: 200,
                      width: 400,
                      child: Card(
                        child: Stack(children: <Widget>[
                          Positioned(
                            width: 350,
                            top: 20,
                            left: 20,
                            child: _setBoundary(),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 100,
                            child: Text(
                              "Enable alerts :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 35,
                            right: 100,
                            child: Checkbox(
                              value: settings.enableAlerts,
                              onChanged: (value) => _setAlerts(value),
                            ),
                          ),
                        ],),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}