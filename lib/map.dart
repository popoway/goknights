import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class MyMapPage extends StatefulWidget {
  const MyMapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyMapPage> createState() => _MyMapPageState();
}

Set<Marker> markers = <Marker>{};

class _MyMapPageState extends State<MyMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: PlatformMap(
              padding: const EdgeInsets.only(
                  bottom: 64.0, top: 8.0, left: 16.0, right: 16.0),
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.736366, -73.819483),
                zoom: 16.0,
                bearing: 278.0,
              ),
              markers: <Marker>{
                Marker(
                  markerId: MarkerId('marker_bldg_su'),
                  position: const LatLng(40.7342822, -73.8160786),
                  infoWindow: const InfoWindow(
                    title: 'Student Union (SU)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_cep1'),
                  position: const LatLng(40.734542, -73.816850),
                  infoWindow: const InfoWindow(
                    title: 'Continuing Education Programs 1 (CEP1)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_cep2'),
                  position: const LatLng(40.73429, -73.816890),
                  infoWindow: const InfoWindow(
                    title: 'Tech Incubator (CEP2)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_rz'),
                  position: const LatLng(40.734700, -73.818052),
                  infoWindow: const InfoWindow(
                    title: 'Razran Hall (RZ)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_hh'),
                  position: const LatLng(40.734640, -73.818547),
                  infoWindow: const InfoWindow(
                    title: 'Honors Hall (HH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_re'),
                  position: const LatLng(40.7349748, -73.8190762),
                  infoWindow: const InfoWindow(
                    title: 'Remsen Hall (RE)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_dy'),
                  position: const LatLng(40.735033, -73.816905),
                  infoWindow: const InfoWindow(
                    title: 'Delany Hall (DY)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ch'),
                  position: const LatLng(40.735125, -73.817525),
                  infoWindow: const InfoWindow(
                    title: 'Colwin Hall (CH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_sb'),
                  position: const LatLng(40.734899, -73.820224),
                  infoWindow: const InfoWindow(
                    title: 'Science Building (SB)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_qh'),
                  position: const LatLng(40.737241, -73.824508),
                  infoWindow: const InfoWindow(
                    title: 'Queens Hall (QH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ks'),
                  position: const LatLng(40.737361, -73.814287),
                  infoWindow: const InfoWindow(
                    title: 'Kissena Hall (KS)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_jh'),
                  position: const LatLng(40.7352096, -73.8160514),
                  infoWindow: const InfoWindow(
                    title: 'Jefferson Hall (JH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ky'),
                  position: const LatLng(40.735925, -73.816146),
                  infoWindow: const InfoWindow(
                    title: 'Kiely Hall (KY)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_fh'),
                  position: const LatLng(40.735706, -73.817433),
                  infoWindow: const InfoWindow(
                    title: 'Frese Hall (FH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_kp'),
                  position: const LatLng(40.736206, -73.817245),
                  infoWindow: const InfoWindow(
                    title: 'Klapper Hall (KP)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ph'),
                  position: const LatLng(40.736033, -73.819013),
                  infoWindow: const InfoWindow(
                    title: 'Powdermaker Hall (PH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_cm'),
                  position: const LatLng(40.736230, -73.818377),
                  infoWindow: const InfoWindow(
                    title: 'Campbell Dome (CM)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ro'),
                  position: const LatLng(40.736356, -73.819942),
                  infoWindow: const InfoWindow(
                    title: 'Rosenthal Library (RO)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_st'),
                  position: const LatLng(40.737155, -73.81973),
                  infoWindow: const InfoWindow(
                    title: 'The Summit (ST)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_fg'),
                  position: const LatLng(40.738139, -73.819352),
                  infoWindow: const InfoWindow(
                    title: 'FitzGerald Gym (FG)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_dh'),
                  position: const LatLng(40.737219, -73.817559),
                  infoWindow: const InfoWindow(
                    title: 'Dining Hall (DH)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_mu'),
                  position: const LatLng(40.737802, -73.817023),
                  infoWindow: const InfoWindow(
                    title: 'Music Building (MU)',
                    snippet:
                        'Aaron Copland School of Music\nLeFrak Concert Hall',
                  ),
                  consumeTapEvents: false,
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ca'),
                  position: const LatLng(40.738004, -73.815819),
                  infoWindow: const InfoWindow(
                    title: 'Colden Auditorium (CA)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_gt'),
                  position: const LatLng(40.737836, -73.815219),
                  infoWindow: const InfoWindow(
                    title: 'Goldstein Theatre (GT)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_ra'),
                  position: const LatLng(40.737473, -73.816267),
                  infoWindow: const InfoWindow(
                    title: 'Rathaus Hall (RA)',
                  ),
                ),
                Marker(
                  markerId: MarkerId('marker_bldg_kg'),
                  position: const LatLng(40.737012, -73.815268),
                  infoWindow: const InfoWindow(
                    title: 'King Hall (KG)',
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
                    LatLng(40.737580, -73.814947),
                    LatLng(40.737585, -73.814026),
                    LatLng(40.737197, -73.814040),
                    LatLng(40.737203, -73.814852),
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
                  fillColor: const Color.fromARGB(70, 255, 255, 255),
                  strokeColor: Colors.red,
                  strokeWidth: 4,
                ),
              },
              mapType: MapType.satellite,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: false,
              rotateGesturesEnabled: false,
            ),
          ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search buildings...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
