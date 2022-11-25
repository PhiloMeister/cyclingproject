import 'package:cyclingproject/pages/newRoutePage.dart';
import 'package:cyclingproject/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:geolocator/geolocator.dart';
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
  var userLocation = LatLng(46.28732243981999, 7.535148068628832) ;
  late MapController _mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: userLocation,
          zoom: 15.0,
        ),
        mapController: _mapController,
        children: [
          TileLayer(
            urlTemplate: maps[currentMap],
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg',
              'id': 'mapbox.mapbox-streets-v8'
            },
          ),
          MarkerLayer(markers: [Marker(
            point: userLocation,
            builder: (context) => const Icon(
              Icons.location_on_rounded,
              color: Colors.blueAccent,
              size: 25,
            ),
          )]),
          PolylineLayer(
            polylines: [
              Polyline(points: points, strokeWidth: 5.0, color: Colors.red),
            ],
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                tooltip: 'Current location',
                onPressed: () => {getCurrentLocation()},
                child:
                const Icon(Icons.location_searching)
              ),
              const SizedBox(
                height: 20.0,
              ),
              FloatingActionButton(
                backgroundColor: const Color(0XFF1f1f1f),
                tooltip: 'Change map',
                onPressed: () => {changeMap()},
                child:const Icon(Icons.map_outlined)

              ),
              const SizedBox(
                height: 70.0,
              ),
          ],)
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
  void getCurrentLocation() async{

    var position =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high );
    _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

  }

}
