import 'package:flutter/material.dart';
import 'package:metro_route_finder/home_page.dart';

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
            Container(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  splashColor: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                  child: const Center(
                      child: Text(
                    'Get Started',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
