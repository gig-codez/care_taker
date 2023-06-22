// ignore_for_file: use_build_context_synchronously
import 'dart:async';

// import 'package:location/location.dart' as l;

import 'package:care_taker/views/home/pages/widgets/mapWidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../controllers/MainController.dart';
import '/controllers/LocationController.dart';
import '/exports/exports.dart';

const String androidApiKey = "AIzaSyDIIUClw731TnLo1JLVZi_Yxw59l11g3b0";
const String iOSApiKey = "AIzaSyBYnoDH981M_gkl8vYb_gQxpb0-9ZinMuA";
final Set<Map<String, dynamic>> geofenceZones = {
  {
    'zone': 'Green Zone',
    'pos': const LatLng(0.2575137, 32.5451041),
    'color': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    'c': Colors.greenAccent,
  },
  {
    'zone': 'Red Zone',
    'pos': const LatLng(0.2675137, 32.5451041),
    'color': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    'c': Colors.redAccent,
  },
  {
    'zone': 'Yellow Zone',
    'pos': const LatLng(0.2875137, 32.5451041),
    'color': BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    'c': Colors.yellowAccent,
  },
};

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // Location location = Location();
  @override
  void initState() {
    super.initState();
    context.read<LocationController>().updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    // invoke determinePosition() from location controller
    BlocProvider.of<LocationController>(context).updateLocation();
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        body: ChangeNotifierProvider(
          create: (context) => MainController(),
          builder: (c, x) => GoogleMap(
            markers: geofenceZones
                .map(
                  (e) => Marker(
                    icon: e['color'],
                    markerId: MarkerId(e.keys.first),
                    position: e['pos'],
                    onTap: () {
                      // print(e.keys.first);
                    },
                  ),
                )
                .toSet(),
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
                target: LatLng(0.2475137, 32.5451041),
                zoom: 49.151926040649414),
            circles: geofenceZones
                .map(
                  (e) => Circle(
                    circleId: CircleId(e.keys.first),
                    center: e['pos'],
                    radius: 50,
                    strokeColor: e['c'],
                    onTap: () {
                      // print(e.keys.first);
                    },
                  ),
                )
                .toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        panel: const PanelData(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    final position = await GeolocatorPlatform.instance.getCurrentPosition();
    //  await determinePosition();
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 92.8334901395799,
            target: LatLng(position.latitude, position.longitude),
            tilt: 0.440717697143555,
            zoom: 89.151926040649414),
      ),

    );
    Map<String,dynamic> d = {
       'zone': 'Yellow Zone',
    'pos':  LatLng(position.latitude, position.longitude),
    'color': BitmapDescriptor.defaultMarker,
    'c': Colors.black,
      };
      geofenceZones.addAll([d]);
  }
}
