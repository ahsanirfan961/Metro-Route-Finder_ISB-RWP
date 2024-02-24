import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_route_finder/Pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/images/metro.png'),
              width: 400,
            ),
            const Text(
              'Metro Route Finder',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 0.5,
                      color: Colors.black,
                    ),
                  ]),
            ),
            const Text(
              'Navigate metro routes with',
              style: TextStyle(
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black,
                    ),
                  ],
                  fontWeight: FontWeight.w100),
            ),
            const Text(
              'confidence!',
              style: TextStyle(
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black,
                    ),
                  ],
                  fontWeight: FontWeight.w100),
            ),
            getStarted(context),
          ],
        ),
      ),
    );
  }


  Widget getStarted(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.deepOrangeAccent,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 30),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Timer(const Duration(milliseconds: 300), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            });
          },
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.orange.shade700,
          borderRadius: BorderRadius.circular(25),
          child: const Center(
              child: Text(
            'Get Started',
            style: TextStyle(
                fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600),
          )),
        ),
      ),
    );
  }
}