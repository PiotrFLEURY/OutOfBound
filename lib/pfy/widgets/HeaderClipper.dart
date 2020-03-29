import 'package:flutter/material.dart';

Path getHeaderPath(Size size) {
  final path = Path();
  path.lineTo(0, size.height * .8);
  path.quadraticBezierTo(
      size.width / 2, size.height + 32, size.width, size.height * .8);

  path.lineTo(size.width, 0);
  path.close();

  return path;
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return getHeaderPath(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class HeaderShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = getHeaderPath(size);
    canvas.drawShadow(path, Colors.black45, 1.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
