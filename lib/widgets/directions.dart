// import 'package:cyclingproject/pages/new_route_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// class directions extends StatefulWidget {
//   const directions({super.key});
//
//   @override
//   State<directions> createState() => _directionsState();
// }
//
// class _directionsState extends State<directions> {
//   var maps = [
//     "https://wmts20.geo.admin.ch/1.0.0/ch.swisstopo.swissimage/default/current/3857/{z}/{x}/{y}.jpeg",
//     "https://wmts.geo.admin.ch/1.0.0/ch.swisstopo.pixelkarte-farbe/default/current/3857/{z}/{x}/{y}.jpeg"
//   ];
//   var currentMap = 0;
//   var userLocation = LatLng(46.28732243981999, 7.535148068628832);
//   late MapController _mapController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentLocation();
//     _mapController = MapController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FlutterMap(
//       options: MapOptions(
//         center: userLocation,
//         zoom: 15.0,
//         onTap: (tapPosition, point) => canEdit?addPoint(point):{},
//       ),
//       // mapController: _mapController,
//       children: [
//         // TileLayer(
//           urlTemplate: maps[currentMap],
//         ),
//         MarkerLayer(markers: markers),
//         PolylineLayer(
//           polylines: [
//             Polyline(
//                 points: points, strokeWidth: 5.0, color: Colors.red),
//           ],
//         ),
//       ],
//     );
//   }
//
//   void getCurrentLocation() async {
//     var position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     _mapController.move(LatLng(position.latitude, position.longitude), 16.0);
//     setState(() {
//       userLocation = LatLng(position.latitude, position.longitude);
//     });
//     var marker = Marker(
//       point: userLocation,
//       builder: (context) => const Icon(
//         Icons.location_on_rounded,
//         color: Colors.blueAccent,
//         size: 25,
//       ),
//     );
//     markers.add(marker);
//   }
// }
