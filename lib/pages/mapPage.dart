import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:latlong2/latlong.dart';


void main() {
  runApp(const MyMap());
}

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

  // Hardcoded markers to test, later use firebase
  final _markers = [
    LatLng(46.28294058464128, 7.5387422133790745),
    LatLng(46.29273682028264, 7.5361982764216275),
  ];
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        //Center map on this position
        center: LatLng(46.28732243981999, 7.535148068628832),
        zoom: 15.0,
      ),
      mapController: MapController(),
      children: [
        // Use the default layer from fleaflet
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          //urlTemplate: 'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/{z}/{y}/{x}.jpeg',
        ),
        // Draw a solid polyline between the markers 
        PolylineLayer(
          polylines: [
            Polyline(points: <LatLng>[
              LatLng(46.28294058464128, 7.5387422133790745),
              LatLng(46.29273682028264, 7.5361982764216275),
            ], strokeWidth: 3.0, color: Colors.blue),
          ],
        ),
        // Adding multiple markers to the map
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(46.28294058464128, 7.5387422133790745),
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
            Marker(
              point: LatLng(46.29273682028264, 7.5361982764216275),
              builder: (context) => const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        )
      ],
    ));
  }
}
