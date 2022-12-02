import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';


OpenRouteService openrouteservice = OpenRouteService(apiKey: '5b3ce3597851110001cf62485afeed71f08b4739924b681a09925e6e', profile: ORSProfile.cyclingMountain);

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
  var data;
//For holding instance of Polyline
  final Set<Polyline> polyLines = {};

  // Dummy Start and Destination Points
double startLat = 0.0;
double startLng = 0.0;
double endLat = 0.0;
double endLng = 0.0;

  var maps = [
    "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg",
    "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg"
  ];
  var currentMap = 0;
  var userLocation = LatLng(46.28732243981999, 7.535148068628832);
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
            child: const Icon(Icons.location_searching)),
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
        builder: (context) => const Icon(
          Icons.location_on_rounded,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
      points.add(point);
    } else {
      if (markers.length >= 3) {
        markers.removeLast();
      }
      endLat = point.latitude;
      endLng = point.longitude;
      startLat = points[points.length-1].latitude;
      startLng = points[points.length-1].longitude;
      getCoordinate();
      Marker marker = Marker(
        point: point,
        builder: (context) => const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }
  }

  void removePoint() {
    // Remove last marker and point


    for(int i=0; i<points.length;i++){
      points.removeLast();
    }
    // Add marker to last -1
    if (points.isNotEmpty) {
      markers.removeLast();
      Marker marker = Marker(
        point: points[points.length - 1],
        builder: (context) => const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }

    // If no points, remove marker
    if (points.isEmpty) {
      if(markers.length>1) {
        markers.removeLast();
      }
    }

    // Refresh screen
    setState(() {});
  }

  void validateTrip(point) {
    if (points.isEmpty) {
      Marker marker = Marker(
        point: point,
        builder: (context) => const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 25,
        ),
      );
      markers.add(marker);
    }
  }

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

void getCoordinate() async {
  var start = ORSCoordinate(latitude: startLat, longitude: startLng);
  var end = ORSCoordinate(latitude: endLat, longitude: endLng);

  final List<ORSCoordinate> routeCoordinates = await openrouteservice.directionsRouteCoordsGet(
    startCoordinate: start,
    endCoordinate: end ,
  );
  routeCoordinates.forEach((point) {
    points.add(LatLng(point.latitude, point.longitude));
  });

 final List<ORSCoordinate> locations =[start, end];
  var distances = await openrouteservice.matrixPost(locations: locations, metrics: ["distance"]);
  var distance = distances.distances[0][1];

  var durations = await openrouteservice.matrixPost(locations: locations);
  var duration = durations.durations[0][1];

  print("$distance m");
  print("$duration sec");



  setState(() {});

}



  
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
