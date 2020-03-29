import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Out of bounds app', () {
    final pfyMainBtnFinder = find.byValueKey('PfyMainBtn');

    FlutterDriver driver;

    setUpAll(() async {
      Process.run(
        'adb',
        [
          'shell',
          'pm',
          'grant',
          'com.example.OutOfBounds',
          'android.permission.ACCESS_FINE_LOCATION',
        ],
      );
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    test('Opens main page', () async {
      await driver.tap(pfyMainBtnFinder);

      final headerIndicatorFinder = find.byValueKey('headerIndicator');

      expect(headerIndicatorFinder != null, true);

      final page0 = find.byValueKey('AnimatedNavBarItem#0');
      final page1 = find.byValueKey('AnimatedNavBarItem#1');
      final page2 = find.byValueKey('AnimatedNavBarItem#2');

      await driver.tap(page0);

      expect(await driver.getText(find.byValueKey('noStartLocationText')),
          'No starting position registered');

      await driver.tap(page1);

      expect(
          await driver.getText(find.byValueKey('makeAsStartText'),
              timeout: Duration(seconds: 10)),
          'Make as start');

      await driver.tap(page2);
    });
  });
}
