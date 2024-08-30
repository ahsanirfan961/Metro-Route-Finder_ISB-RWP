import 'dart:io';

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Stack(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(
                child: Image(
                  image: AssetImage('assets/images/orange_material.jpg'),
                ),
                // decoration: const BoxDecoration(color: Color(0xFFFF6E40)),
              ),
              Container(
                height: 70,
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
          ]),
          const ListTile(
            title: Center(
              child: Text(
                'Metro Route Finder',
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            dense: true,
          ),
          const ListTile(
            title: Center(
                child: Text(
              'Islamabad',
              style: TextStyle(fontSize: 20, color: Colors.black87),
            )),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            dense: true,
          ),
          const ListTile(
            title: Center(
                child: Text(
              'v1.01',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            )),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            minVerticalPadding: 0,
            horizontalTitleGap: 0,
            dense: true,
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.share),
          //   title: const Text('Share'),
          //   onTap: () {},
          // ),
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
