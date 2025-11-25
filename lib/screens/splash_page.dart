import 'dart:async';

import 'package:almoterfy/constants/constants.dart';
import 'package:almoterfy/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: const HomePage(),
          type: PageTransitionType.fade,
          duration: const Duration(seconds: 2),
          reverseDuration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      color: Constants.themeColor,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            './Assets/images/splash.jpg',
            fit: BoxFit.fill,
            width: size.width,
            height: size.height,
          ),
          Positioned(
            bottom: 140,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Constants.iconsColor,
            ),
          ),
        ],
      ),
    );
  }
}
