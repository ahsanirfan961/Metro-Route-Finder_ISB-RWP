import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metro_route_finder/Pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  Future<void> displayLocationUsageMsg(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    var duration = const Duration(milliseconds: 200);
    if (firstTime == null || firstTime) {
      prefs.setBool('first_time', false);
      Timer(duration, () {
        locationUsageMsg(context);
      });
    }
  }

  void locationUsageMsg(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Usage'),
          content: const Text(
              'This app may access your location, if you decide to navigate through your current location. Do you agree?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Agree'),
            ),
            TextButton(
              onPressed: () {
                exit(0);
              },
              child: const Text('Disagree'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    displayLocationUsageMsg(context);
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
