// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/functions.dart';

class MapMarkers extends ValueNotifier<Set<Marker>> {
  MapMarkers._internal() : super({});
  static final MapMarkers _markers = MapMarkers._internal();

  factory MapMarkers() {
    return _markers;
  }

  void addMarker(Marker marker) {
    value.add(marker);
    notifyListeners();
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  // const MapWidget._internal();
  // static const MapWidget _mapWidget = MapWidget._internal();

  // factory MapWidget() {
  //   return _mapWidget;
  // }

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const _initPosition =
      LatLng(33.6451274, 73.03); // Rawalpindi Islamabad
  final _mapPadding = const EdgeInsets.only(bottom: 250, left: 10);
  var _mapCreated = false;
  var _stationsEnabled = false;
  MapMarkers markers = MapMarkers();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
            valueListenable: MapMarkers(),
            builder: (context, value, child) {
              return GoogleMap(
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                padding: _mapPadding,
                initialCameraPosition:
                    const CameraPosition(target: _initPosition, zoom: 12),
                markers: value,
                onMapCreated: (controller) async {
                  await setStationMarkers();
                  _mapCreated = true;
                  setState(() {});
                },
              );
            }),
        getLoading(),
        getStationButton()
      ],
    );
  }

  Widget getStationButton() {
    return Positioned(
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
                  _stationsEnabled
                      ? markers.value.addAll(stationMarkers)
                      : markers.value.removeAll(stationMarkers);
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
    );
  }

  Widget getLoading() {
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
