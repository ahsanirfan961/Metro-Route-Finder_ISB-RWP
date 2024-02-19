import 'package:flutter/material.dart';
import 'package:metro_route_finder/bottom_sheet.dart';
import 'package:metro_route_finder/map.dart';
import 'package:metro_route_finder/nav_bar.dart';

BuildContext? homeContext;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      locationPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    homeContext = context;
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
          backgroundColor: Colors.white.withAlpha(255),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: const Border(
              bottom: BorderSide(color: Colors.black54, width: 0.5))),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: MapWidget(),
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        builder: (BuildContext context) => const MainBottomSheet(),
        onClosing: () {},
      ),
    );
  }
}
