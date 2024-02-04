import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:metro_route_finder/bottom_sheet.dart';
import 'package:metro_route_finder/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapController controller = MapController(
    initMapWithUserPosition:
        const UserTrackingOption(enableTracking: true, unFollowUser: false),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
          foregroundColor: Colors.deepOrangeAccent,
          backgroundColor: Colors.white.withAlpha(255),
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          shape: const Border(
              bottom: BorderSide(color: Colors.black54, width: 0.5))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
                color: Colors.white,
                child: OSMFlutter(
                    controller: controller,
                    onMapIsReady: (isReady) async {
                      if (isReady) {
                        await Future.delayed(const Duration(seconds: 1),
                            () async {
                          await controller.currentLocation();
                        });
                      }
                    },
                    osmOption: OSMOption(
                      showZoomController: true,
                      userTrackingOption: const UserTrackingOption(
                        enableTracking: true,
                        unFollowUser: false,
                      ),
                      zoomOption: const ZoomOption(
                        initZoom: 10,
                        minZoomLevel: 2,
                        maxZoomLevel: 19,
                        stepZoom: 1.0,
                      ),
                      userLocationMarker: UserLocationMaker(
                        personMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                        directionArrowMarker: const MarkerIcon(
                          icon: Icon(
                            Icons.double_arrow,
                            size: 48,
                          ),
                        ),
                      ),
                      roadConfiguration: const RoadOption(
                        roadColor: Colors.yellowAccent,
                      ),
                      markerOption: MarkerOption(
                          defaultMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 56,
                        ),
                      )),
                    ))),
          ),
        ],
      ),
      bottomSheet: BottomSheet(
        builder: (BuildContext context) => const MainBottomSheet(),
        onClosing: () {},
      ),
    );
  }
}
