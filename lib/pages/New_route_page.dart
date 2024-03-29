import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/BusinessObjectManager/RouteManager.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

import '../theme/constants.dart';
import '../utils/snackbar.dart';

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

  // Normal markers
  var markers = <Marker>[];
  var points = <LatLng>[];
  var pointsListLat = <double>[];
  var pointsListLng = <double>[];

  // Danger Markers
  var dangerMarkers = <Marker>[];
  var dangerPoints = <LatLng>[];
  var dangerpointsListLat = <double>[];
  var dangerpointsListLng = <double>[];
  var isDanger = false;

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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            child: FlutterMap(
              options: MapOptions(
                center: userLocation,
                zoom: 15.0,
                maxZoom: 18,
                onTap: (tapPosition, point) => canEdit ? addPoint(point) : {},
              ),
              mapController: _mapController,
              children: [
                TileLayer(
                  urlTemplate: maps[currentMap],
                ),
                MarkerLayer(markers: markers),
                MarkerLayer(markers: dangerMarkers),
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
            Positioned(
              top: 60,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: kPrimaryColor,
                          offset: Offset(10, 10),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.social_distance_sharp,
                          size: 12,
                          color: Colors.white,
                        ),
                        addHorizontalSpace(5),
                        Text(
                          "Distance: ${(distanceTotal / 1000).toStringAsFixed(3)} km",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  addHorizontalSpace(10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: kPrimaryColor,
                          offset: Offset(10, 10),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 12,
                          color: Colors.white,
                        ),
                        addHorizontalSpace(5),
                        Text(
                          "Duration: ${(durationTotal / 60).toStringAsFixed(2)} min",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
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
          SpeedDialChild(
            child: const Icon(
              CupertinoIcons.exclamationmark_octagon_fill,
            ),
            label: "Danger",
            onTap: () => {toggleDanger()},
          ),
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

// Switch isDanger boolean
  void toggleDanger() {
    if (!isDanger) {
      isDanger = true;
    } else {
      isDanger = false;
    }
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
          title: const Text(
            "Enter a name for the route",
            style: TextStyle(fontSize: 13),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: "Routename",
              hintStyle: const TextStyle(color: kTextColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: kTextColor),
              ),
            ),
            style: const TextStyle(
              color: kTextColor,
              fontSize: 13,
            ),
            onChanged: (routeName) {
              setState(() {
                myRoute.routeName = routeName;
                print("the name route2 $routeName");
              });
            },
          ),
          actions: [
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                icon: const Icon(
                    color: kPrimaryLightColor, Icons.save_sharp, size: 13),
                label: const Text(
                  'Save route',
                  style: TextStyle(color: kPrimaryLightColor, fontSize: 13),
                ),
                onPressed: () {
                  addRouteFirestore(routes);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );

  Future<void> addRouteFirestore(Routes myRoute) async {
    myRoute.routeLenght = distanceTotal.toDouble();
    myRoute.routeDuration = durationTotal.toDouble();
    myRoute.pointsLat = pointsListLat;
    myRoute.pointsLng = pointsListLng;
    myRoute.dangerPointsLat = dangerpointsListLat;
    myRoute.dangerPointsLng = dangerpointsListLng;
    myRoute.routeDifficulty = distanceTotal > 10000
        ? "Hard"
        : distanceTotal > 5000
            ? "Medium"
            : "Easy";
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

      Utils.showSnackBar("Your route has been saved!", false);

      // Clear map to remove points after adding on the database
      removePoint();
    } else {
      Utils.showSnackBar("A route with this name already exists :(", true);
      ;
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

  // Add a danger marker meaning avoiding a zone
  Marker addDangerMarker(LatLng point) {
    Marker marker = Marker(
      point: point,
      builder: (context) => const Icon(
        CupertinoIcons.exclamationmark_octagon_fill,
        color: Colors.yellowAccent,
        size: 25,
      ),
    );
    return marker;
  }

  // Add a point on the map
  void addPoint(LatLng point) {
    if (!isDanger) {
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
    } else {
      // Add the points to list for database
      dangerpointsListLat.add(point.latitude);
      dangerpointsListLng.add(point.longitude);

      // Place marker on the map
      Marker marker = addDangerMarker(point);
      dangerMarkers.add(marker);

      // Set isDanger to false
      isDanger = false;

      // Refresh screen
      setState(() {});
    }
  }

  // Delete markers and points displayed
  void removePoint() {
    points.removeRange(0, points.length);
    dangerPoints.removeRange(0, dangerPoints.length);

    markers.removeRange(0, markers.length);
    dangerMarkers.removeRange(0, dangerMarkers.length);

    pointsListLat.removeRange(0, pointsListLat.length);
    pointsListLng.removeRange(0, pointsListLng.length);
    dangerpointsListLat.removeRange(0, dangerpointsListLat.length);
    dangerpointsListLng.removeRange(0, dangerpointsListLng.length);

    distanceTotal = 0.0;
    durationTotal = 0.0;

    // Refresh screen
    setState(() {});
  }

  // Get the current position of the user by clicking on the position button
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
    setState(
      () {
        userLocation = LatLng(position.latitude, position.longitude);
      },
    );
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
