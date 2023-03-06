import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musicly/widgets/bottom_nav.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      (() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => BottomNav()),
            ),
          )),
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splashload.gif'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
