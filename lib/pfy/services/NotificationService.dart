import 'package:OutOfBounds/pfy/services/SettingsService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

const CHANNEL_ID = "my_channel_id";
const CHANNEL_NAME = "my_channel";
const CHANNEL_DESCRIPTION = "my_channel_description";

const NOTIFICATION_TRACKING_ID = 1;
const NOTIFICATION_ALERT_ID = 2;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  SettingsService settingsService = GetIt.instance.get<SettingsService>();

  bool _userNotified = false;

  void cancelNotification(int id) async =>
      await flutterLocalNotificationsPlugin.cancel(id);

  void notify(int id, String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        CHANNEL_ID, CHANNEL_NAME, CHANNEL_DESCRIPTION,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: null);
  }

  void initNotifications(BuildContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('fence');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onDidReceiveLocalNotification(context, id, title, body, payload));
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings
        /*,
      onSelectNotification: (payload) =>
          onSelectNotification(context, payload)*/
        );
  }

  Future onSelectNotification(BuildContext context, payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.pushNamed(context, "/pfy");
  }

  Future onDidReceiveLocalNotification(BuildContext context, int id,
      String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.pushNamed(context, "/pfy");
            },
          )
        ],
      ),
    );
  }

  void updateAlertNotification(double distanceFromStart) {
    bool outOfBounds = distanceFromStart != null &&
        distanceFromStart > settingsService.boundary;
    if (_userNotified && !outOfBounds) {
      cancelNotification(NOTIFICATION_ALERT_ID);
      _userNotified = false;
    }
    if (settingsService.enableAlerts && outOfBounds && !_userNotified) {
      notify(NOTIFICATION_ALERT_ID, "OutOfBounds",
          "Alert ! You are ${distanceFromStart - settingsService.boundary} meter too far from your starting point");
      _userNotified = true;
    }
  }
}
