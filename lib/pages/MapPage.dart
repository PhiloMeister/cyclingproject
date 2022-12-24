import 'package:cyclingproject/BusinessObject/Routes.dart';
import 'package:cyclingproject/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../theme/constants.dart';

OpenRouteService openrouteservice = OpenRouteService(
    apiKey: '5b3ce3597851110001cf62485afeed71f08b4739924b681a09925e6e',
    profile: ORSProfile.cyclingMountain);

// ignore: camel_case_types
class Map_Page extends StatelessWidget {
  const Map_Page({super.key, required this.myRoute});
  final Routes myRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: kTextColor,
                  size: 18,
                )),
          ),
        ),
        /*title: const Text(
          "My Account",
          style: TextStyle(color: kTextColor),
        ),*/
        centerTitle: true,
      ),
      body: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: MapPage(routeToDisplay: myRoute),
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
  final panelController = PanelController();
  static const double fabHeightClosed = 110.0;
  double fabHeight = fabHeightClosed;

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
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.09;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.2;

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
                  Polyline(points: points, strokeWidth: 5.0, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            /*Positioned(
              top: 60,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: kTextColor,
                      size: 18,
                    )),
              ),
            ),*/
            Positioned(
              top: 60,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Route: ${routeToDisplay.routeName}",
                  style: const TextStyle(
                      color: kTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SlidingUpPanel(
              color: kPrimaryLightColor,
              controller: panelController,
              maxHeight: panelHeightOpen,
              minHeight: panelHeightClosed,
              panelBuilder: (controller) => PanelWidget(
                  controller: controller,
                  panelController: panelController,
                  routeToDisplay: routeToDisplay),
              parallaxEnabled: true,
              parallaxOffset: .5,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              onPanelSlide: ((position) => setState(() {
                    final panelMaxScrollExtent =
                        panelHeightOpen - panelHeightClosed;

                    fabHeight =
                        position * panelMaxScrollExtent + fabHeightClosed;
                  })),
            ),
            Positioned(
              right: 20,
              bottom: fabHeight,
              child: buildFAB(context),
            ),
          ],
        ),
        /*if (routeToDisplay.routeLenght != 0.0) ...[
            ColoredBox(
              color: const Color.fromARGB(255, 217, 217, 217),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(children: [
                  Text(
                      "Distance: ${(routeToDisplay.routeLenght! / 1000).toStringAsFixed(2)} km ",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                      "Duration: ${(routeToDisplay.routeDuration! / 60).toStringAsFixed(0)} min ${(routeToDisplay.routeDuration! % 60).toStringAsFixed(0)} sec",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 20)),
                ]),
              ),
            ),
          ],*/
      ],
    ));
  }

  Widget buildFAB(BuildContext context) => SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        backgroundColor: const Color(0XFF1f1f1f),
        spacing: 0,
        spaceBetweenChildren: 12,
        closeManually: false,
        children: [
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
        ],
      );

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

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Routes routeToDisplay;

  const PanelWidget(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.routeToDisplay})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          addVerticalSpace(12),
          buildDragHandle(),
          addVerticalSpace(18),
          buildAboutText(),
          addVerticalSpace(24)
        ],
      );

  Widget buildAboutText() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("Informations",
                  style: TextStyle(
                      color: kTitleColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600)),
            ),
            addVerticalSpace(30),
            if (routeToDisplay.routeLenght != 0.0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    /*decoration: BoxDecoration(
                      border: Border.all(color: kSecondaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    )*/
                    child: Column(children: [
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Distance:",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: kPrimaryColor, fontSize: 12),
                            ),
                            Text(
                              "${(routeToDisplay.routeLenght! / 1000).toStringAsFixed(2)} km ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                  Column(children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      /*decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),*/
                      child: Column(
                        children: [
                          const Text(
                            "Time:",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 12),
                          ),
                          Text(
                            "${(routeToDisplay.routeDuration! / 60).toStringAsFixed(2)} min",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ],
          ],
        ),
      );

  Widget buildDragHandle() => GestureDetector(
        onTap: togglePanel,
        child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  void togglePanel() => panelController.isPanelOpen
      ? panelController.close()
      : panelController.open();
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
