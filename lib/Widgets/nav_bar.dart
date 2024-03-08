import 'dart:io';

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(
                height: 155,
                child: Image(
                  image: AssetImage('assets/images/orange_material.jpg'),
                  // height: 100,
                ),
                // decoration: const BoxDecoration(color: Color(0xFFFF6E40)),
              ),
              Container(
                height: 150,
              )
            ]),
            const Positioned(
              left: 95,
              top: 90,
              child: CircleAvatar(
                  backgroundColor: Color(0xFFFAF0F1),
                  radius: 60,
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 110,
                    height: 110,
                  )),
            ),
            const Positioned(
                top: 220,
                left: 35,
                child: Text(
                  'Metro Route Finder',
                  style: TextStyle(fontSize: 24, color: Colors.black87),
                )),
            const Positioned(
                top: 250,
                left: 100,
                child: Text(
                  'Islamabad',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )),
            const Positioned(
                top: 275,
                left: 135,
                child: Text(
                  'v1.01',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ))
          ]),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_sharp),
            title: const Text('Exit'),
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}
