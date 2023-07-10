import 'package:care_taker/exports/exports.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/FencesController.dart';
import '../../controllers/mainController.dart';
import 'YellowZone.dart';

class SetGeofence extends StatefulWidget {
  const SetGeofence({Key? key}) : super(key: key);

  @override
  State<SetGeofence> createState() => _SetGeofenceState();
}

class _SetGeofenceState extends State<SetGeofence> {
  Position? position;
  MainController? controller;
  bool isSet = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    initializeLocationPermissions();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSet)
              Text(
                "Latitude: ${position!.latitude}, Longitude: ${position!.longitude}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            if (isLoading)
              const CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                Geolocator.getCurrentPosition().then((value) {
                  setState(() {
                    isSet = true;
                    isLoading = false;
                    position = value;
                  });
                  BlocProvider.of<FencesController>(context).setFences({
                    'zone': 'Green Zone',
                    'pos': LatLng(value.latitude, value.longitude),
                    'color': BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                    'c': Colors.green,
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const YellowZone();
                    }),
                  );
                  
                });
              },
              child: const Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.add_location_alt,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading == false)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tap to set the green zone.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
