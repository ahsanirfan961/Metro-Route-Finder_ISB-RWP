// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/Widgets/map.dart';
import 'package:metro_route_finder/controllers/map_data.dart';
import 'package:metro_route_finder/controllers/station.dart';
import 'package:metro_route_finder/functions.dart';

class MapLocation {
  String address = '';
  LatLng? position;

  MapLocation(this.address);
}

class MainBottomSheet extends StatefulWidget {
  const MainBottomSheet({super.key});

  @override
  State<MainBottomSheet> createState() => _MainBottomSheetState();
}

class _MainBottomSheetState extends State<MainBottomSheet>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  MapLocation source = MapLocation('Start Location');
  MapLocation destination = MapLocation('Destination');

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
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              source.address = searchLocation.address;
                              source.position = searchLocation.position;
                              MapDataState().addFixedMarker(Marker(
                                  markerId: const MarkerId('source'),
                                  position: source.position!,
                                  icon: await getCustomIcon(
                                      'assets/images/bus_stop_start.png'),
                                  infoWindow: const InfoWindow(
                                      title: 'Starting Location')));
                              MapWidgetState()
                                  .animateCameraTo(source.position!);
                              MapDataState().clearRoute();
                            } else if (index == 1) {
                              destination.address = searchLocation.address;
                              destination.position = searchLocation.position;
                              MapDataState().addFixedMarker(Marker(
                                  markerId: const MarkerId('destination'),
                                  position: destination.position!,
                                  icon: await getCustomIcon(
                                      'assets/images/bus_stop_end.png'),
                                  infoWindow:
                                      const InfoWindow(title: 'Destination')));
                              MapWidgetState()
                                  .animateCameraTo(destination.position!);
                              MapDataState().clearRoute();
                            }
                            setState(() {});
                          }
                        },
                        leading: const Icon(Icons.location_on),
                        title: Text(
                          index == 0 ? source.address : destination.address,
                        ),
                      ),
                      const Divider()
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    if (source.position != null &&
                        destination.position != null) {
                      var startStation = getNearestStationTo(source.position!);
                      var destStation =
                          getNearestStationTo(destination.position!);

                      /*checking that if the distance between the source location 
                      and destination location is not actually less than the 
                      distance that the traveller needs to cover to reach the 
                      metro station*/
                      var absDistance = calculateDistanceBetweenLocations(
                          await getPolylineCoordinates(
                              source.position!, destination.position!));

                      var metroDistance = calculateDistanceBetweenLocations(
                              await getPolylineCoordinates(source.position!,
                                  stationPositions[startStation])) +
                          calculateDistanceBetweenLocations(
                              await getPolylineCoordinates(
                                  destination.position!,
                                  stationPositions[destStation]));

                      if (absDistance <= 0.5 * metroDistance) {
                        MapDataState().addPolyline('route', source.position!,
                            destination.position!, Colors.blue);
                        ScaffoldMessenger.of(context as BuildContext)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                    'No Metro Route exists between these locations!')));
                        return;
                      }

                      // creating route to start station
                      MapDataState()
                          .addRouteMarker(getStationMarker(startStation));
                      MapDataState().addPolyline('source', source.position!,
                          stationPositions[startStation], Colors.blue);

                      // creating route to destination station
                      MapDataState()
                          .addRouteMarker(getStationMarker(destStation));
                      MapDataState().addPolyline(
                          'destination',
                          destination.position!,
                          stationPositions[destStation],
                          Colors.blue);

                      // creating route between metro stations
                      var stationLayout = StationLayout();
                      var route =
                          stationLayout.pathBetween(startStation, destStation);
                      for (int i = 0; i < route.length - 1; i++) {
                        Color color = stationColors[route[i]] ??
                            stationColors[route[i + 1]];
                        MapDataState()
                            .addRouteMarker(getStationMarker(route[i]));
                        MapDataState().addCustomPolyline(Polyline(
                            polylineId:
                                PolylineId("${route[i]}+${route[i + 1]}"),
                            color: color,
                            points: [
                              stationPositions[route[i]],
                              stationPositions[route[i + 1]]
                            ],
                            width: POLYLINE_WIDTH,
                            startCap: Cap.roundCap,
                            endCap: Cap.roundCap));
                      }
                    }
                  } catch (e) {
                    showConnectionError(context as BuildContext);
                  }
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepOrangeAccent),
                    elevation: MaterialStatePropertyAll(3)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Find Route',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ]),
    );
  }
}

// ignore: must_be_immutable
class SearchBottomSheet extends StatelessWidget {
  final searchController = TextEditingController();

  SearchBottomSheet({super.key});

  MapLocation searchLocation = MapLocation('');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [getDraggableLine(context), getSearchField(context)]),
    );
  }

  Widget getDraggableLine(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (1 / 2),
      height: 5,
      margin: const EdgeInsets.only(top: 5),
      decoration: const BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(2.5))),
    );
  }

  Widget getSearchField(BuildContext context) {
    return Padding(
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
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    onTap: () async {
                      try {
                        if (await locationPermission(context)) {
                          if (await gpsEnabled()) {
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
                      } catch (e) {
                        showConnectionError(context);
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
        ));
  }
}
