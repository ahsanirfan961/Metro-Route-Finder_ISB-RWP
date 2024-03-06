import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/functions.dart';

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