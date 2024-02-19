// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:metro_route_finder/widget_to_map_icon.dart';
import 'package:permission_handler/permission_handler.dart';

Location location = Location();

Future<LocationData> getCurrentLocation() async {
  final locationData = await location.getLocation();
  return locationData;
}

Future<bool> gpsEnabled() async {
  if (await location.serviceEnabled()) {
    return true;
  }
  location.requestService();
  return false;
}

Future<bool> locationPermission(BuildContext context) async {
  const permission = Permission.location;
  if (await permission.isDenied) {
    permission.request();
    return false;
  } else if (await permission.isPermanentlyDenied) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permisiion Required'),
            content: const Text(
                'Navigate to "Application Permissions" and allow location permissions'),
            actions: [
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              )
            ],
          );
        });
    return false;
  } else {
    return true;
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initPosition = LatLng(33.6451274, 73.03);
  final _mapPadding = const EdgeInsets.only(bottom: 250, left: 10);
  var _mapCreated = false;
  var _stationsEnabled = true;
  Set<Marker>? markers = {};

  Future<BitmapDescriptor> getCustomIcon(String imagePath) async {
    return SizedBox(
      height: 40,
      width: 40,
      child: Image.asset(imagePath),
    ).toBitmapDescriptor();
  }

  void setMarkers() async {
    markers = <Marker>{
      Marker(
          markerId: const MarkerId('Islamabad International Airport'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.56095189895278, 72.83700608010443),
          infoWindow: const InfoWindow(
              title: 'Islamabad International Airport Station')),
      Marker(
          markerId: const MarkerId('26 Number'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6322, 72.9445),
          infoWindow: const InfoWindow(title: '26 Number Station')),
      Marker(
          markerId: const MarkerId('Golra'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6406, 72.9617),
          infoWindow: const InfoWindow(title: 'Golra Mor Station')),
      Marker(
          markerId: const MarkerId('G-13'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6496, 72.9817),
          infoWindow: const InfoWindow(title: 'Nust/G-13 Station')),
      Marker(
          markerId: const MarkerId('G-12'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6560, 72.9933),
          infoWindow: const InfoWindow(title: 'G-12 Station')),
      Marker(
          markerId: const MarkerId('G-11'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6630, 73.0074),
          infoWindow:
              const InfoWindow(title: 'Police Foundation/G-11 Station')),
      Marker(
          markerId: const MarkerId('G-10'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6677, 73.0162),
          infoWindow: const InfoWindow(title: 'G-10 Station')),
      Marker(
          markerId: const MarkerId('G-9'),
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
          position: const LatLng(33.6773, 73.0347),
          infoWindow: const InfoWindow(title: 'G-9/H-9/NHA Station')),
      Marker(
          markerId: const MarkerId('Faiz Ahmad Faiz'),
          icon: await getCustomIcon("assets/images/bus_stop_red_orange.png"),
          position: const LatLng(33.6760, 73.0550),
          infoWindow: const InfoWindow(title: 'Faiz Ahmad Faiz Station')),
      Marker(
          markerId: const MarkerId('Kashmir Highway'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.6852, 73.0460),
          infoWindow: const InfoWindow(title: 'Kashmir Highway Station')),
      Marker(
          markerId: const MarkerId('Chaman'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.6900, 73.0428),
          infoWindow: const InfoWindow(title: 'Chaman Station')),
      Marker(
          markerId: const MarkerId('Ibn-e-Sina'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.69644905648759, 73.03787753824244),
          infoWindow: const InfoWindow(title: 'Ibn-e-Station Station')),
      Marker(
          markerId: const MarkerId('Katchery'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.702277863666204, 73.04095186708203),
          infoWindow: const InfoWindow(title: 'Katchery Station')),
      Marker(
          markerId: const MarkerId('Centaurus'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.705782187100176, 73.04800458576659),
          infoWindow: const InfoWindow(title: 'Centaraus/PIMS Station')),
      Marker(
          markerId: const MarkerId('Stock Exchange'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.711776123432024, 73.05929907233532),
          infoWindow: const InfoWindow(title: 'Stock Exchange Station')),
      Marker(
          markerId: const MarkerId('7th Avenue'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.71820764009457, 73.07122404926015),
          infoWindow: const InfoWindow(title: '7th Avenue Station')),
      Marker(
          markerId: const MarkerId('Shaheed-e-Millat'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.72171475110865, 73.07838322360071),
          infoWindow: const InfoWindow(title: 'Shaheed-e-Millat Station')),
      Marker(
          markerId: const MarkerId('Parade Ground'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.724787448975356, 73.08440118751071),
          infoWindow: const InfoWindow(title: 'Parade Ground Station')),
      Marker(
          markerId: const MarkerId('Pak Secteriat'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.73520048315413, 73.09240868463804),
          infoWindow: const InfoWindow(title: 'Pak Secteriat Station')),
      Marker(
          markerId: const MarkerId('Khayaban-e-Johar'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.669269533315536, 73.05926209299133),
          infoWindow: const InfoWindow(title: 'Khayaban-e-Johar Station')),
      Marker(
          markerId: const MarkerId('Potohar'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.661339247653224, 73.06533269353748),
          infoWindow: const InfoWindow(title: 'Potohar Station')),
      Marker(
          markerId: const MarkerId('IJP'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.656279745233846, 73.07169728444373),
          infoWindow: const InfoWindow(title: 'IJP Station')),
      Marker(
          markerId: const MarkerId('Faizabad'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.661439645834534, 73.08285873967888),
          infoWindow: const InfoWindow(title: 'Faizabad Station')),
      Marker(
          markerId: const MarkerId('Shamsabad'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.650559681688584, 73.07987327890962),
          infoWindow: const InfoWindow(title: 'Shamsabad Station')),
      Marker(
          markerId: const MarkerId('6th Road'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.64343291633432, 73.07769155117246),
          infoWindow: const InfoWindow(title: '6th Road Station')),
      Marker(
          markerId: const MarkerId('Rehmanabad'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.63630855661862, 73.07491837615183),
          infoWindow: const InfoWindow(title: 'Rehmanabad Station')),
      Marker(
          markerId: const MarkerId('Chandni Chowk'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.62964818779046, 73.0716458948337),
          infoWindow: const InfoWindow(title: 'Chandni Chowk Station')),
      Marker(
          markerId: const MarkerId('Waris Khan'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.62227647847515, 73.06686863325669),
          infoWindow: const InfoWindow(title: 'Waris Khan Station')),
      Marker(
          markerId: const MarkerId('Committee Chowk'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.613427486726145, 73.06468910324138),
          infoWindow: const InfoWindow(title: 'Committee Chowk Station')),
      Marker(
          markerId: const MarkerId('Liaquat Bagh'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.60611998948246, 73.06567619296001),
          infoWindow: const InfoWindow(title: 'Liaquat Bagh Station')),
      Marker(
          markerId: const MarkerId('Marir Chowk'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.59951162680857, 73.0626556170475),
          infoWindow: const InfoWindow(title: 'Marir Chowk Station')),
      Marker(
          markerId: const MarkerId('Saddar'),
          icon: await getCustomIcon("assets/images/bus_stop.png"),
          position: const LatLng(33.59380798939582, 73.05603698821746),
          infoWindow: const InfoWindow(title: 'Saddar Station')),
    };
    setState(() {});
  }

  void hello(){
    print('Hello');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          padding: _mapPadding,
          initialCameraPosition:
              const CameraPosition(target: _initPosition, zoom: 12),
          markers: _stationsEnabled ? markers! : <Marker>{},
          onMapCreated: (controller) {
            _mapCreated = true;
            setMarkers();
          },
        ),
        loading(),
        Positioned(
          top: 60,
          right: 7,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                ElevatedButton(
                    onPressed: () {
                      _stationsEnabled = !_stationsEnabled;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                        fixedSize: const Size(38, 38),
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(0, 0),
                        backgroundColor: Colors.white.withAlpha(240),
                        foregroundColor: Colors.transparent),
                    child: const Image(
                      image: AssetImage('assets/images/bus.png'),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget loading() {
    return !_mapCreated
        ? Padding(
            padding: _mapPadding,
            child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.deepOrangeAccent, size: 50)),
          )
        : const Text('');
  }
}
