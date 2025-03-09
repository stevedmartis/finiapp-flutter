import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/login/success_animation_widget.dart';
import 'package:flutter/material.dart';

Route bubleSuccessRouter() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return BublesSuccesPage();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 0.5);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
