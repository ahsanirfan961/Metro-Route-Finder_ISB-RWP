import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro_route_finder/Pages/welcome_page.dart';
import 'package:metro_route_finder/dependency_injection.dart';

void main() {
  runApp(const App());
  DependencyInjection.init();
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Metro Route Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
          useMaterial3: true,
          fontFamily: 'Nexa'),
      home: const WelcomePage(title: ''),
    );
  }
}
