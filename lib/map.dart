import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MyMapPage extends StatefulWidget {
  const MyMapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyMapPage> createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PlatformMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(40.736366, -73.819483),
            zoom: 16.0,
            bearing: 278.0,
          ),
          markers: <Marker>{
            Marker(
              markerId: MarkerId('marker_1'),
              position: const LatLng(40.735925, -73.816146),
              infoWindow: const InfoWindow(
                title: 'Kiely Hall',
              ),
            ),
            Marker(
              markerId: MarkerId('marker_2'),
              position: const LatLng(40.7342822, -73.8160786),
              infoWindow: const InfoWindow(
                title: 'Student Union',
              ),
            ),
          },
          // draw campus boundary
          polygons: <Polygon>{
            Polygon(
              polygonId: PolygonId('polygon_1'),
              // add 4 points to the polygon to form a square
              points: const <LatLng>[
                LatLng(40.738761, -73.820056),
                LatLng(40.738314, -73.816937),
                LatLng(40.738354, -73.816337),
                LatLng(40.738845, -73.816076),
                LatLng(40.738480, -73.815042), // HK
                LatLng(40.736853, -73.814772),
                LatLng(40.733871, -73.814933), // KM
                LatLng(40.733904, -73.816044),
                LatLng(40.734528, -73.821773), // M1
                LatLng(40.735320, -73.821584),
                LatLng(40.735547, -73.821827),
                LatLng(40.735428, -73.822867),
                LatLng(40.736327, -73.822791),
                LatLng(40.736389, -73.825008), // Queens
                LatLng(40.737811, -73.824842), // Hall
                LatLng(40.737711, -73.823002),
                LatLng(40.738224, -73.822918),
                LatLng(40.739344, -73.822830),
              ],
              consumeTapEvents: true,
              fillColor: Color.fromARGB(80, 255, 255, 255),
              strokeColor: Colors.red,
              strokeWidth: 2,
            ),
          },
          mapType: MapType.satellite,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onTap: (location) => print('onTap: $location'),
          onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
          compassEnabled: false,
          rotateGesturesEnabled: false,
          // onMapCreated: (controller) {
          //   Future.delayed(const Duration(seconds: 2)).then(
          //     (_) {
          //       controller.animateCamera(
          //         CameraUpdate.newCameraPosition(
          //           const CameraPosition(
          //             bearing: 270.0,
          //             target: LatLng(40.7369971, 73.8207127),
          //             tilt: 30.0,
          //             zoom: 18,
          //           ),
          //         ),
          //       );
          //       controller
          //           .getVisibleRegion()
          //           .then((bounds) => print("bounds: ${bounds.toString()}"));
          //     },
          //   );
          // },
        ),
      ),
    );
  }
}
