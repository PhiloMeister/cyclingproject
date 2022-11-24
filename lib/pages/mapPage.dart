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
      home: MyHomePage(title: 'Navigate to my map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // var points = <LatLng>[
  //   new LatLng(46.28294058464128, 7.5387422133790745),
  //   new LatLng(46.29273682028264, 7.5361982764216275),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  FlutterMap(
          options: MapOptions(
            center: LatLng(46.28732243981999, 7.535148068628832),
            zoom: 15.0,
          ),
          mapController: MapController(),
          children: [
            TileLayer(
              urlTemplate: "https://api.mapbox.com/styles/v1/glacia/clauxhpdp007715qmh37hhvdn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg",
              additionalOptions: const {
                'accessToken': 'pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg',
                'id': 'mapbox.mapbox-streets-v8'
              },
              //userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              //urlTemplate: 'https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/{z}/{y}/{x}.jpeg',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(46.28294058464128, 7.5387422133790745),
                  builder: (context) => const Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                ),
                Marker(
                  point: LatLng(46.29273682028264, 7.5361982764216275),
                  builder: (context) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        ),
         );

    // new PolylineLayer(
    //   polylines: [
    //     new Polyline(points: points, strokeWidth:  5.0, color: Colors.red),
    //   ],
    // );
  }
}
