import 'package:OutOfBounds/pfy/widgets/HeaderClipper.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final double height;

  Header({this.height = 150});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HeaderShadow(),
      child: ClipPath(
        clipper: HeaderClipper(),
        child: Container(
          height: height,
          width: double.infinity,
          child: Image.asset(
            "assets/images/googlemap.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
