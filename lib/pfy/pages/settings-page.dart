import 'package:OutOfBounds/pfy/services/NotificationService.dart';
import 'package:OutOfBounds/pfy/services/SettingsService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
SettingsService settingsService = getIt.get<SettingsService>();
NotificationService notificationService = getIt.get<NotificationService>();

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = settingsService.boundary.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // BOUDARY
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withAlpha(50),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                labelText: 'Boundary',
                labelStyle: TextStyle(
                  color: Colors.orange,
                ),
              ),
              controller: _controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                settingsService.boundary = double.parse(value);
              },
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              autocorrect: false,
              keyboardType: TextInputType.number,
            ),
            // ENABLE ALERTS
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Enable alerts",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: settingsService.enableAlerts,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      settingsService.enableAlerts = value;
                      if (value) {
                        notificationService.notify(NOTIFICATION_TRACKING_ID,
                            "Out of bounds", "Tracking enabled");
                      } else {
                        notificationService
                            .cancelNotification(NOTIFICATION_TRACKING_ID);
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
