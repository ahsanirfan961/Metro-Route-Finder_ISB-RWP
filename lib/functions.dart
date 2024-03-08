// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:metro_route_finder/Widgets/bottom_sheet.dart';
import 'package:metro_route_finder/Widgets/widget_to_map_icon.dart';
import 'package:metro_route_finder/const.dart';
import 'package:metro_route_finder/controllers/map_data.dart';
import 'package:metro_route_finder/controllers/station.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<BitmapDescriptor> getCustomIcon(String imagePath) async {
  return SizedBox(
    height: 40,
    width: 40,
    child: Image.asset(imagePath),
  ).toBitmapDescriptor();
}

Future<void> setStationMarkers() async {
  stationMarkers = <Marker>{};
  var iconPath = 'assets/images/bus_stop_orange.png';
  for (final stationName in stationPositions.keys) {
    if (stationName == 'Kashmir Highway') {
      iconPath = 'assets/images/bus_stop.png';
    }
    if (stationName == 'Faiz Ahmad Faiz') {
      iconPath = 'assets/images/bus_stop_red_orange.png';
    }
    stationMarkers.add(Marker(
        markerId: MarkerId(stationName),
        icon: await getCustomIcon(iconPath),
        position: stationPositions[stationName],
        infoWindow: InfoWindow(title: '$stationName Station')));
    if (stationName == 'Faiz Ahmad Faiz') {
      iconPath = 'assets/images/bus_stop.png';
    }
  }
}

double distanceBetweenPoints(LatLng source, LatLng dest) {
  return sqrt(pow(source.latitude - dest.latitude, 2) +
      pow(source.longitude - dest.longitude, 2));
}

Future<List<LatLng>> getPolylineCoordinates(
    LatLng source, LatLng destination) async {
  List<LatLng> coordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true);
  if (result.points.isNotEmpty) {
    result.points.forEach((element) {
      coordinates.add(LatLng(element.latitude, element.longitude));
    });
  }
  return coordinates;
}

String getNearestStationTo(LatLng position) {
  var station = stationPositions.keys.first;
  var distanceFromStation =
      distanceBetweenPoints(position, stationPositions[station]);
  for (var stationName in stationPositions.keys) {
    var distance =
        distanceBetweenPoints(stationPositions[stationName], position);
    if (distance < distanceFromStation) {
      distanceFromStation = distance;
      station = stationName;
    }
  }
  return station;
}

Marker getStationMarker(String station) {
  var marker;
  for (var i in stationMarkers) {
    if (i.markerId.value == station) {
      marker = i;
    }
  }
  return marker;
}

double calculateDistanceBetweenPoints(LatLng start, LatLng end) {
  var conversionFactor =
      0.017453292519943295; // conversion factor to convert radians to decimal
  var a = 0.5 -
      cos((end.latitude - start.latitude) * conversionFactor) / 2 +
      cos(start.latitude * conversionFactor) *
          cos(end.latitude * conversionFactor) *
          (1 - cos((end.longitude - start.longitude) * conversionFactor)) /
          2;
  return 12742 * asin(sqrt(a));
}

//it will return distance in KM

double calculateDistanceBetweenLocations(List<LatLng> points) {
  double totalDistance = 0;
  for (var i = 0; i < points.length - 1; i++) {
    totalDistance += calculateDistanceBetweenPoints(
      points[i],
      points[i + 1],
    );
  }
  return totalDistance;
}

void showConnectionError(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Error!'),
          content: const Text(
              'Please check your internet connection and try again later'),
          icon: const Icon(Icons.error, size: 50),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      });
}

Future<void> findRoute(BuildContext context, MapLocation source, MapLocation destination) async
{
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
          ScaffoldMessenger.of(context)
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
      showConnectionError(context);
    }
}
