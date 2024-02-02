import 'package:flutter/material.dart';
import 'package:metro_route_finder/bottom_sheet.dart';
import 'package:metro_route_finder/nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        foregroundColor: Colors.deepOrangeAccent,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
            ),
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
