import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NewRoutePage extends StatelessWidget {
  const NewRoutePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewRoute(),
    );
  }
}

class NewRoute extends StatefulWidget {
  const NewRoute({super.key});

  @override
  State<NewRoute> createState() => _NewRouteState();
}

class _NewRouteState extends State<NewRoute> {
  // LatLng(46.28294058464128, 7.5387422133790745), bellevue
  // LatLng(46.29273682028264, 7.5361982764216275), technopole

  var points = <LatLng>[];
  var markers = <Marker>[];
  var maps = [
    "https://api.mapbox.com/styles/v1/glacia/clauxhpdp007715qmh37hhvdn/tiles/256/{z}/{x}/{y}@2x?"
        "access_token=pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg",
    "https://api.mapbox.com/styles/v1/glacia/claw7eka3008e15o2avubu12x/tiles/256/{z}/{x}/{y}@2x?"
        "access_token=pk.eyJ1IjoiZ2xhY2lhIiwiYSI6ImNsYXV4NWNnZDAwODgzeW81ODJkNzlxaWcifQ.GHlRSCMMR-M9BzZg9247Cg"
  ];
  var currentMap = 0;
  var userLocation = LatLng(46.28732243981999, 7.535148068628832);
  late MapController _mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    addMarkerCurrentLocation();
    _mapController = MapController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: userLocation,
          zoom: 15.0,
          onTap: (tapPosition, point) => addPoint(point),
        ),
        mapController: _mapController,
        children: [
          TileLayer(
            urlTemplate: maps[currentMap],
          ),
          MarkerLayer(markers: markers),
          PolylineLayer(
            polylines: [
              Polyline(points: points, strokeWidth: 5.0, color: Colors.red),
            ],
          ),
        ],
      ),
      floatingActionButton:
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () => {removePoint()},
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Cancel point',
          child: const Icon(Icons.arrow_back_outlined),
        ),
        const SizedBox(
          height: 20.0,
        ),
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
          onPressed: () => {changeMap()},
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Change map',
          child: const Icon(Icons.map_outlined),
        ),
        const SizedBox(
          height: 70.0,
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  void addPoint(LatLng point) {
    if (points.isEmpty) {
      Marker marker = Marker(
        point: point,
        builder: (context) =>
        const Icon(
          Icons.location_on_rounded,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    } else {
      if (markers.length >= 2) {
        markers.removeLast();
      }
      Marker marker = Marker(
        point: point,
        builder: (context) =>
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }
    points.add(point);
  }

  void removePoint() {
    // Remove last marker and point
    markers.removeLast();
    points.removeLast();

    // Add marker to last -1
    if (points.isNotEmpty) {
      Marker marker = Marker(
        point: points.elementAt(points.length - 1),
        builder: (context) =>
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }

    // If no points, remove marker
    if (points.isEmpty) {
      markers.removeLast();
    }

    // Refresh screen
    setState(() {});
  }

  void validateTrip(point) {
    if (points.isEmpty) {
      Marker marker = Marker(
        point: point,
        builder: (context) =>
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }
  }

  void getCurrentLocation() async{

    var position =  await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high );
    _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });

  }

  void addMarkerCurrentLocation(){
    var marker =Marker(
      point: userLocation,
      builder: (context) => const Icon(
        Icons.location_on_rounded,
        color: Colors.blueAccent,
        size: 25,
      ),
    );
    markers.add(marker);
  }
}
