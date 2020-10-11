import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class WaveClipper extends CustomClipper<Path> {
  //This Cliper have the height 35% screen

  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height * 0.28);
    var firstControlPoint = new Offset(size.width / 4, (size.height * 0.33));
    var firstEndPoint = new Offset(size.width / 2, (size.height * 0.25));
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), (size.height * 0.15));
    var secondEndPoint = new Offset(size.width, (size.height * 0.28));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
