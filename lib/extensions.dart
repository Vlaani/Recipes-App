import 'package:flutter/material.dart';

extension Corrector on List<dynamic> {
  List<T> correct<T>() {
    return List<T>.from(this);
  }
}

class CustomNavRoute<T> extends MaterialPageRoute<T> {
  CustomNavRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
