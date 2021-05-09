import 'package:flutter/cupertino.dart';

class CustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var sw = size.width;
    var sh = size.height;
    var controlPoint = Offset(size.width / 3, -(size.height / 4));
    var endPoint = Offset(size.width, size.height);

    Path path = Path();
// / Adds a cubic bezier segment that curves from the current point
//   /// to the given point (x3,y3), using the control points (x1,y1) and
//   /// (x2,y2).
//   void cubicTo(double x1, double y1, double x2, double y2, double x3, double y3) native 'Path_cubicTo';

    path.lineTo(size.width / 4, 0);
    path.cubicTo(sw / 4, 0, sw / 4,  sh / 4, 2 * sw / 3,   sh / 5);
    path.cubicTo(3 * sw / 4,sh / 6, 3 * sw / 5, 0,  sw -(sw/4), 0);
    path.lineTo(size.width, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
