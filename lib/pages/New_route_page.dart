import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

OpenRouteService openrouteservice = OpenRouteService(
    apiKey: '5b3ce3597851110001cf62485afeed71f08b4739924b681a09925e6e',
    profile: ORSProfile.cyclingMountain);

Routes routes = Routes();

class NewRoutePage extends StatelessWidget {
  const NewRoutePage({super.key, required this.canEdit});
  final bool canEdit;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewRoute(
        canEdit: canEdit,
      ),
    );
  }
}

class NewRoute extends StatefulWidget {
  const NewRoute({super.key, required this.canEdit});
  final bool canEdit;

  @override
  State<NewRoute> createState() => _NewRouteState(canEdit);
}

class _NewRouteState extends State<NewRoute> {
  final bool canEdit;
  var points = <LatLng>[];
  var markers = <Marker>[];
  var pointsListLat = <double>[];
  var pointsListLng = <double>[];
  var data;

  // Dummy Start and Destination Points
  double startLat = 0.0;
  double startLng = 0.0;
  double endLat = 0.0;
  double endLng = 0.0;

  var distanceTotal = 0.0;
  var durationTotal = 0.0;

  var maps = [
    "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg",
    "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg"
  ];
  var currentMap = 0;
  var userLocation = LatLng(46.28732243981999, 7.535148068628832);
  late MapController _mapController;

  _NewRouteState(this.canEdit);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _mapController = MapController();
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
                onTap: (tapPosition, point) => canEdit ? addPoint(point) : {},
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
          if (distanceTotal != 0.0) ...[
            ColoredBox(
              color: const Color.fromARGB(255, 217, 217, 217),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(children: [
                  Text(
                      "Distance: ${(distanceTotal / 1000).toStringAsFixed(3)} km ",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                      "Duration: ${(durationTotal / 60).toStringAsFixed(2)} min",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20)),
                ]),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        backgroundColor: const Color(0XFF1f1f1f),
        spacing: 0,
        spaceBetweenChildren: 12,
        closeManually: false,
        children: [
          canEdit
              ? SpeedDialChild(
                  child: const Icon(Icons.arrow_back),
                  label: "Remove",
                  onTap: () => {removePoint()},
                )
              : SpeedDialChild(),
          SpeedDialChild(
            child: const Icon(Icons.location_searching),
            label: "Current location",
            onTap: () => {getCurrentLocation()},
          ),
          SpeedDialChild(
            child: const Icon(Icons.map_outlined),
            label: "Change map",
            onTap: () => {changeMap()},
          ),
          points.length >= 2
              ? SpeedDialChild(
                  child: const Icon(Icons.save),
                  label: "Save",
                  onTap: () => {saveRouteDialog(routes)},
                )
              : SpeedDialChild()
        ],
      ),
    );
  }

  // Switch between satellite and default map
  void changeMap() {
    if (currentMap == 0) {
      currentMap = 1;
    } else {
      currentMap = 0;
    }
    setState(() {});
  }

  // After clicking on save button, shows a dialog view to enter the name of the route
  void saveRouteDialog(Routes myRoute) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              title: const Text("Enter a name for the route"),
              content: TextField(
                onChanged: (routeName) {
                  setState(() {
                    myRoute.routeName = routeName;
                  });
                },
              ),
              actions: [
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    addRouteFirestore(routes);
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.save),
                )
              ]));

  Future<void> addRouteFirestore(Routes myRoute) async {
    myRoute.routeLenght = distanceTotal.toDouble();
    myRoute.routeDuration = durationTotal.toDouble();
    myRoute.pointsLat = pointsListLat;
    myRoute.pointsLng = pointsListLng;
    myRoute.routeDifficulty = distanceTotal > 1000 ? "Hard" : "Easy";
    myRoute.routeCreator = await FirebaseAuth.instance.currentUser?.uid;

    // Test if the name already exists
    var testOnName;
    await getIdOfRouteByName(myRoute.routeName.toString())
        .then((value) => setState(() {
              testOnName = value;
            }));

    if (testOnName == null) {
      // Add the route to the database
      addRoute(routes);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Your route has been saved!"),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1500),
      ));

      // Clear map to remove points after adding on the database
      removePoint();
      
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("A route with this name already exists :("),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 1500),
      ));
    }
  }

  // Add a marker
  Marker addMarker(LatLng point) {
    Marker marker = Marker(
      point: point,
      builder: (context) => const Icon(
        Icons.location_on_rounded,
        color: Colors.red,
        size: 25,
      ),
    );
    return marker;
  }

  // Add a point on the map
  void addPoint(LatLng point) {
    // Add the points to list for database
    pointsListLat.add(point.latitude);
    pointsListLng.add(point.longitude);

    if (points.isEmpty) {
      Marker marker = addMarker(point);
      markers.add(marker);
      points.add(point);
    } else {
      if (markers.length >= 2) {
        markers.removeLast();
      }
      endLat = point.latitude;
      endLng = point.longitude;
      startLat = points[points.length - 1].latitude;
      startLng = points[points.length - 1].longitude;

      // Get the lines from the API
      getCoordinate();

      // Place marker on the map
      Marker marker = addMarker(point);
      markers.add(marker);
    }
  }

  // Delete markers and points displayed
  void removePoint() {
    points.removeRange(0, points.length);
    markers.removeRange(0, markers.length);
    pointsListLat.removeRange(0, pointsListLat.length);
    pointsListLng.removeRange(0, pointsListLng.length);
    distanceTotal = 0.0;
    durationTotal = 0.0;

    // Refresh screen
    setState(() {});
  }

  // Get the current position of the user by clicking on the position button
  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
    var marker = Marker(
      point: userLocation,
      builder: (context) => const Icon(
        Icons.location_on_rounded,
        color: Colors.blueAccent,
        size: 25,
      ),
    );
    markers.add(marker);
  }

  // Get the duration and distance of a given route
  void getCoordinate() async {
    var start = ORSCoordinate(latitude: startLat, longitude: startLng);
    var end = ORSCoordinate(latitude: endLat, longitude: endLng);

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

    // Refresh screen
    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
