import 'package:flutter/material.dart';

class InfoClipPath extends CustomClipper<Path> {
  InfoClipPath(this.w_k, this.lb);
  final double w_k, lb;

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.moveTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.lineTo(w_k, 0);
    path.quadraticBezierTo(w_k - lb, 0, 0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
