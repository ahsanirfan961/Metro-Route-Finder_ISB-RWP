// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/map.dart';

class MapLocation {
  String address = '';
  LatLng position = const LatLng(0, 0);
}

class MainBottomSheet extends StatefulWidget {
  const MainBottomSheet({super.key});

  @override
  State<MainBottomSheet> createState() => _MainBottomSheetState();
}

class _MainBottomSheetState extends State<MainBottomSheet>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  String startAddress = 'Start Location';
  String destAddress = 'Destination';

  @override
  void initState() {
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
    _animationController!.duration = const Duration(milliseconds: 400);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView.builder(
                itemCount: 2, // Number of items in the ListView
                shrinkWrap: true, // Allow the ListView to wrap its content
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          var searchLocation =
                              await showModalBottomSheet<MapLocation>(
                            context: context,
                            builder: (BuildContext context) =>
                                SearchBottomSheet(),
                            transitionAnimationController: _animationController,
                            isScrollControlled: true,
                          );
                          if (searchLocation != null) {
                            if (index == 0) {
                              startAddress = searchLocation.address;
                            } else if (index == 1) {
                              destAddress = searchLocation.address;
                            }
                            setState(() {});
                          }
                        },
                        leading: const Icon(Icons.location_on),
                        title: Text(
                          index == 0 ? startAddress : destAddress,
                        ),
                      ),
                      const Divider()
                    ],
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
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
              ),
            )
          ]),
    );
  }
}

class SearchBottomSheet extends StatelessWidget {
  final searchController = TextEditingController();

  SearchBottomSheet({super.key});

  MapLocation searchLocation = MapLocation();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width * (1 / 2),
          height: 5,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.all(Radius.circular(2.5))),
        ),
        Padding(
            padding: const EdgeInsets.all(20),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: searchController,
              googleAPIKey: GOOGLE_MAPS_API_KEY,
              inputDecoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  hintText: 'Search Location',
                  icon: const Icon(Icons.search_rounded),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        onTap: () async {
                          if (await locationPermission(context)) {
                            if (await gpsEnabled()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Location found!')));
                              var currentLocation = await getCurrentLocation();
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                      currentLocation.latitude!,
                                      currentLocation.longitude!);
                              searchLocation.position = LatLng(
                                  currentLocation.latitude!,
                                  currentLocation.longitude!);
                              searchLocation.address =
                                  "${placemarks[0].street}, ${placemarks[0].subLocality}";
                              Navigator.pop(context, searchLocation);
                            }
                          }
                        },
                        child: const Icon(Icons.location_searching_rounded)),
                  )),
              debounceTime: 800,
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                searchLocation.position = LatLng(
                    double.parse(prediction.lat.toString()),
                    double.parse(prediction.lng.toString()));
                Navigator.pop(context, searchLocation);
              },
              itemClick: (Prediction prediction) {
                searchLocation.address = prediction.description!;
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  color: const Color.fromRGBO(250, 240, 242, 1.0),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(child: Text(prediction.description ?? ""))
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(
                height: 1,
              ),
              containerHorizontalPadding: 10,
            ))
      ]),
    );
  }
}
