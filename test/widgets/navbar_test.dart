import 'package:OutOfBounds/pfy/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  TestApp({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: child,
      ),
    );
  }
}

void main() {
  group("Navbar init", () {
    testWidgets("Navbar should fail if items < 2", (WidgetTester tester) async {
      var error;
      try {
        await tester.pumpWidget(
          TestApp(
            child: AnimatedNavBar(
              items: [
                AnimatedNavBarItem(
                  image: AssetImage("assets/images/mansion.png"),
                  text: "Mansion",
                ),
              ],
              onTap: (index) {},
            ),
          ),
        );
      } catch (e) {
        error = e;
      }
      expect(error != null, true);
    });
  });
  group("Navbar usage", () {
    testWidgets("Navbar should select default item",
        (WidgetTester tester) async {
      final defaultItem = 1;
      AnimatedNavBarController controller = AnimatedNavBarController(
        initialItem: defaultItem,
      );
      await tester.pumpWidget(
        TestApp(
          child: AnimatedNavBar(
            controller: controller,
            items: [
              AnimatedNavBarItem(
                image: AssetImage("assets/images/mansion.png"),
                text: "Mansion",
              ),
              AnimatedNavBarItem(
                image: AssetImage("assets/images/road.png"),
                text: "Road",
              ),
            ],
            onTap: (index) {},
          ),
        ),
      );
      assert(controller.currentItem == defaultItem, true);
    });
    testWidgets("Navbar should select user selection",
        (WidgetTester tester) async {
      final defaultItem = 1;
      final userSelection = 0;
      AnimatedNavBarController controller = AnimatedNavBarController(
        initialItem: defaultItem,
      );
      await tester.pumpWidget(
        TestApp(
          child: AnimatedNavBar(
            controller: controller,
            items: [
              AnimatedNavBarItem(
                image: AssetImage("assets/images/mansion.png"),
                text: "Mansion",
              ),
              AnimatedNavBarItem(
                image: AssetImage("assets/images/road.png"),
                text: "Road",
              ),
            ],
            onTap: (index) {},
          ),
        ),
      );
      await tester.tap(find.byKey(Key("AnimatedNavBarItem#$userSelection")));
      assert(controller.currentItem == userSelection, true);
    });
  });
}
