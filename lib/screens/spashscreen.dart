import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hopin/screens/home.dart';
// import 'package:hopin/screens/publishrideswrapper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'auth/auth.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icon(Icons.directions_car, size: 70),
      nextScreen: Auth(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
