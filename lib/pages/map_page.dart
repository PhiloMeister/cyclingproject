import 'dart:html';
import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:cyclingproject/pages/AllRoutes.dart';
import 'package:cyclingproject/pages/New_route_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

OpenRouteService openrouteservice = OpenRouteService(
    apiKey: '5b3ce3597851110001cf62485afeed71f08b4739924b681a09925e6e',
    profile: ORSProfile.cyclingMountain);

// ignore: camel_case_types
class map_page extends StatelessWidget {
  const map_page({super.key, required this.myRoute});
  final Routes myRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFD9D9D9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Route: ${myRoute.routeName}"),
        centerTitle: true,
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: MapPage(
          routeToDisplay: myRoute,
        ),
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.routeToDisplay});
  final Routes routeToDisplay;

  @override
  // ignore: no_logic_in_create_state
  State<MapPage> createState() => _MapPageState(routeToDisplay);
}

class _MapPageState extends State<MapPage> {
  var points = <LatLng>[];
  var markers = <Marker>[];
  var pointsListLat = <double>[];
  var pointsListLng = <double>[];
  final Routes routeToDisplay;
  var distanceTotal = 0.0;
  var durationTotal = 0.0;

  // 2 types of map that can be switched
  var maps = [
    "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg",
    "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg"
  ];
  var currentMap = 0;
  var userLocation = LatLng(46.28732243981999, 7.535148068628832);
  late MapController _mapController;

  _MapPageState(this.routeToDisplay);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Add markers at start and end positions
    setMarkers(routeToDisplay);

    // Display the polylines
    getCoordinate(routeToDisplay);

    // Refresh scren
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: FlutterMap(
              options: MapOptions(
                center: userLocation,
                zoom: 15.0,
              ),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate: maps[currentMap],
                ),
                MarkerLayer(markers: markers),
                PolylineLayer(
                  polylines: [
                    Polyline(
                        points: points, strokeWidth: 5.0, color: Colors.red),
                  ],
                ),
              ],
            ),
          ),
          if (routeToDisplay.routeLenght != 0.0) ...[
            ColoredBox(
              color: const Color.fromARGB(255, 217, 217, 217),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(children: [
                  Text(
                      "Distance: ${(routeToDisplay.routeLenght! / 1000).toStringAsFixed(2)} mm ",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                      "Duration: ${(routeToDisplay.routeDuration! / 60).toStringAsFixed(2)} min",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20)),
                ]),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: () => {changeMap()},
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Change map',
          child: const Icon(Icons.map_outlined),
        ),
        const SizedBox(
          height: 20.0,
        ),
        FloatingActionButton(
          onPressed: () => {Navigator.of(context).pop()},
          backgroundColor: const Color(0XFF1f1f1f),
          tooltip: 'Return to menu',
          child: const Icon(Icons.home),
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Switch between satellite and default map
  void changeMap() {
    if (currentMap == 0) {
      currentMap = 1;
    } else {
      currentMap = 0;
    }

    // Refresh screen
    setState(() {});
  }

  void setMarkers(Routes myRoute) {

    // Add a start marker 
    Marker markerStart = Marker(
      point: LatLng(myRoute.pointsLat?[0], myRoute.pointsLng?[0]),
      builder: (context) => const Icon(
        Icons.location_on_rounded,
        color: Colors.red,
        size: 25,
      ),
    );

    // Add an end marker
    markers.add(markerStart);
    Marker markerEnd = Marker(
      point: LatLng(myRoute.pointsLat?[myRoute.pointsLat!.length - 1],
          myRoute.pointsLng?[myRoute.pointsLng!.length - 1]),
      builder: (context) => const Icon(
        Icons.location_on_rounded,
        color: Colors.red,
        size: 25,
      ),
    );
    markers.add(markerEnd);

  }

  // Call page to display the route
  void returnToMenu() {
    Navigator.of(context).pop();
  }

  // Get the duration and distance of a given route
  void getCoordinate(Routes myRoute) async {
    for (int i = 1; i < myRoute.pointsLat!.length; i++) {
      var start = ORSCoordinate(
          latitude: myRoute.pointsLat![i - 1],
          longitude: myRoute.pointsLng![i - 1]);
      var end = ORSCoordinate(
          latitude: myRoute.pointsLat![i], longitude: myRoute.pointsLng![i]);

      final List<ORSCoordinate> routeCoordinates =
          await openrouteservice.directionsRouteCoordsGet(
        startCoordinate: start,
        endCoordinate: end,
      );
      routeCoordinates.forEach((point) {
        points.add(LatLng(point.latitude, point.longitude));
      });

      final List<ORSCoordinate> locations = [start, end];
      var distances = await openrouteservice
          .matrixPost(locations: locations, metrics: ["distance"]);
      distanceTotal += distances.distances[0][1];

      var durations = await openrouteservice.matrixPost(locations: locations);
      durationTotal += durations.durations[0][1];
    }

    // Refresh screen
    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
