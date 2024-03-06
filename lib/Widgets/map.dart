// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/controllers/map_data.dart';
import 'package:metro_route_finder/functions.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  static const _initPosition =
      LatLng(33.6451274, 73.03); // Rawalpindi Islamabad
  final _mapPadding = const EdgeInsets.only(bottom: 250, left: 10);
  var _mapCreated = false;
  var _stationsEnabled = false;
  MapDataState markers = MapDataState();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static final MapWidgetState _mapState = MapWidgetState._internal();

  MapWidgetState._internal();

  factory MapWidgetState() {
    return _mapState;
  }

  Future<void> animateCameraTo(LatLng position) async {
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
            valueListenable: MapDataState(),
            builder: (context, value, child) {
              return GoogleMap(
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                padding: _mapPadding,
                initialCameraPosition:
                    const CameraPosition(target: _initPosition, zoom: 12),
                markers: value.getAllMarkers(),
                polylines: Set<Polyline>.of(value.polylines.values),
                onMapCreated: (controller) async {
                  _mapController.complete(controller);
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
                  if (_stationsEnabled) {
                    markers.value.fixedMarkers.addAll(stationMarkers);
                  } else {
                    markers.value.fixedMarkers.removeAll(stationMarkers);
                  }
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
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.deepOrangeAccent.shade700, size: 50)),
          )
        : const Text('');
  }
}
