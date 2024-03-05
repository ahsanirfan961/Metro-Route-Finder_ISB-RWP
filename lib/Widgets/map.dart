// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/functions.dart';

class Station {
  Station({required this.id});
  String id;
  Station? next;

  static Station addStation(Station head, String id) {
    Station current = head;
    Station q = Station(id: id);
    while (current.next != null) {
      current = current.next!;
    }
    current.next = q;
    return head;
  }
}

class StationLayout {
  Map<String, Station> stations = {};
  List<String> _route = [];

  StationLayout() {
    List<Station> list = [];
    for (var i in stationPositions.keys) {
      list.add(Station(id: i));
    }
    for (int i = 0; i < 18; i++) {
      if (i > 0) Station.addStation(list[i], list[i - 1].id);
      Station.addStation(list[i], list[i + 1].id);
    }
    Station.addStation(list[18], list[18 - 1].id);
    Station.addStation(list[8], list[19].id);
    Station.addStation(list[19], list[8].id);
    Station.addStation(list[19], list[20].id);
    for (int i = 20; i <= 31; i++) {
      if (i < 31) Station.addStation(list[i], list[i + 1].id);
      Station.addStation(list[i], list[i - 1].id);
    }
    int j = 0;
    for (var i in stationPositions.keys) {
      stations[i] = list[j];
      j++;
    }
  }

  void printlayout() {
    for (var i in stations.values) {
      var current = i;
      String llist = current.id + " >> ";
      while (current.next != null) {
        current = current.next!;
        llist += current.id + " >> ";
      }
      print(llist);
    }
  }

  bool _dfs(String source, String destination, Map<String, bool> flags) {
    _route.add(source);
    flags[source] = true;
    if (stations[source]!.next == null) {
      return false;
    }
    if (source == destination) return true;

    Station? adjacent = stations[source]!.next;
    while (adjacent != null) {
      if (flags[adjacent.id] == false) {
        if (_dfs(adjacent.id, destination, flags)) return true;
      }
      adjacent = adjacent.next;
    }

    _route.removeLast();
    return false;
  }

  List<String> pathBetween(String source, String destination) {
    Map<String, bool> flags = {};
    _route = [];
    for (var i in stationPositions.keys) {
      flags[i] = false;
    }
    _dfs(source, destination, flags);
    return _route;
  }
}

class MapData {
  Set<Marker> fixedMarkers = {};
  Set<Marker> routeMarkers = {};
  Map<PolylineId, Polyline> polylines = {};

  Set<Marker> getAllMarkers() {
    Set<Marker> markers = {};
    markers.addAll(fixedMarkers);
    markers.addAll(routeMarkers);
    return markers;
  }
}

class MapDataState extends ValueNotifier<MapData> {
  MapDataState._internal() : super(MapData());
  static final MapDataState _mapDataState = MapDataState._internal();

  factory MapDataState() {
    return _mapDataState;
  }

  void addFixedMarker(Marker marker) {
    value.fixedMarkers.add(marker);
    notifyListeners();
  }

  void addRouteMarker(Marker marker) {
    value.routeMarkers.add(marker);
    notifyListeners();
  }

  void clearRoute() {
    value.routeMarkers = {};
    value.polylines = {};
    notifyListeners();
  }

  Future<void> addPolyline(
      String id, LatLng source, LatLng destination, Color color) async {
    PolylineId polylineId = PolylineId(id);
    Polyline polyline = Polyline(
        polylineId: polylineId,
        color: color,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: POLYLINE_WIDTH,
        points: await getPolylineCoordinates(source, destination));
    value.polylines[polylineId] = polyline;
    notifyListeners();
  }

  void addCustomPolyline(Polyline polyline) {
    value.polylines[polyline.polylineId] = polyline;
    notifyListeners();
  }
}

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
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.deepOrangeAccent, size: 50)),
          )
        : const Text('');
  }
}
