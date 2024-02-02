import 'package:flutter/material.dart';

class MainBottomSheet extends StatelessWidget {
  const MainBottomSheet({super.key});

  @override
  Widget build(Object context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 7),
                blurStyle: BlurStyle.normal),
          ]),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RadioMenuButton(
                value: true,
                groupValue: true,
                onChanged: (bool? value) {},
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Set the border radius
                    ),
                  ),
                ),
                child: const Text('Start Location')),
            const Divider(),
            RadioMenuButton(
                value: true,
                groupValue: true,
                onChanged: (bool? value) {},
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Set the border radius
                    ),
                  ),
                ),
                child: const Text('Destination')),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.deepOrangeAccent),
                elevation: MaterialStatePropertyAll(3),
              ),
              child: const Text(
                'Find Route',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
    );
  }
}
