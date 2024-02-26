// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:metro_route_finder/Widgets/widget_to_map_icon.dart';
import 'package:metro_route_finder/const.dart';
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

  double distanceBetweenPoints(LatLng source, LatLng dest)
  {
    return sqrt(pow(source.latitude - dest.latitude, 2) + pow(source.longitude - dest.longitude, 2));
  }
  