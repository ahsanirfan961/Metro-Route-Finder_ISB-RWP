import 'package:flutter/material.dart';
import 'package:metro_route_finder/Pages/welcome_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


