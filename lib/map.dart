import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metro_route_finder/widget_to_map_icon.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initPosition = LatLng(33.6451274, 73.03);
  final _mapPadding = const EdgeInsets.only(bottom: 230, left: 10);
  var _mapCreated = false;
  var _stationsEnabled = true;
  Set<Marker>? markers = <Marker>{};

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
          icon: await getCustomIcon("assets/images/bus_stop_orange.png"),
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
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: true,
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
                    // Bus Station Show button
                    onPressed: () {
                      _stationsEnabled = !_stationsEnabled;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                        fixedSize: const Size(38, 38),
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(0, 0),
                        backgroundColor: Colors.white.withAlpha(240),
                        foregroundColor: Colors.transparent),
                    child: const Image(
                      image: AssetImage('assets/images/metro.png'),
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
            child: const Center(
              child: Text(
                'Loading...',
                style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16),
              ),
            ),
          )
        : const Text('');
  }
}
