import 'package:cyclingproject/pages/newRoutePage.dart';
import 'package:cyclingproject/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:latlong2/latlong.dart';

class MyMap extends StatelessWidget {
  const MyMap({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Get this from firebase
  var points = <LatLng>[];
  var markers = <Marker>[];
  var maps = [
    "https://api.mapbox.com/styles/v1/glacia/clauxhpdp007715qmh37hhvdn/tiles/256/{z}/{x}/{y}@2x?"
        "access_token=pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg",
    "https://api.mapbox.com/styles/v1/glacia/claw7eka3008e15o2avubu12x/tiles/256/{z}/{x}/{y}@2x?"
        "access_token=pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg"
  ];
  var currentMap = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(46.28732243981999, 7.535148068628832),
          zoom: 15.0,
        ),
        mapController: MapController(),
        children: [
          TileLayer(
            urlTemplate: maps[currentMap],
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          MarkerLayer(markers: markers),
          PolylineLayer(
            polylines: [
              Polyline(points: points, strokeWidth: 5.0, color: Colors.red),
            ],
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          tooltip: 'Change map',
          onPressed: () => {changeMap()},
          child: const Icon(Icons.map_outlined),
        ),
      ),
    );
  }

  void changeMap() {
    if (currentMap == 0) {
      currentMap = 1;
    } else {
      currentMap = 0;
    }
    setState(() {});
  }
}
