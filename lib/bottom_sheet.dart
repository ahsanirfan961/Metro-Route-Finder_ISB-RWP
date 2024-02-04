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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RadioMenuButton(
              value: true,
              groupValue: true,
              onChanged: (bool? value) {
                if (value == true) {
                  showModalBottomSheet(
                    context: context as BuildContext,
                    builder: (BuildContext context) => SearchBottomSheet(),
                  );
                }
              },
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: const Text('Start Location'),
            ),
            const Divider(),
            RadioMenuButton(
                value: true,
                groupValue: true,
                onChanged: (bool? value) {
                  if (value == true) {
                    showModalBottomSheet(
                      context: context as BuildContext,
                      builder: (BuildContext context) => SearchBottomSheet(),
                    );
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Text('Destination')),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  // fixedSize: Size(width, height),
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
              ),
            )
          ]),
    );
  }
}

class SearchBottomSheet extends StatelessWidget {
  final searchController = TextEditingController();

  SearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * (1 / 2),
          height: 5,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(2.5))),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
                hintText: 'Search Location', icon: Icon(Icons.search)),
          ),
        )
      ]),
    );
  }
}
