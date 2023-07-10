import 'package:care_taker/controllers/FencesController.dart';
import 'package:care_taker/views/fences/RedZone.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/MainController.dart';
import '../../exports/exports.dart';

class YellowZone extends StatefulWidget {
  const YellowZone({super.key});

  @override
  State<YellowZone> createState() => _YellowZoneState();
}

class _YellowZoneState extends State<YellowZone> {
  Position? position;
  bool isSet = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent,systemNavigationBarDividerColor: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[900],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSet == true)
              Text(
                "Latitude: ${position!.latitude}, Longitude: ${position!.longitude}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                GeolocatorPlatform.instance.getCurrentPosition().then((value) {
                  var x = {
                    'zone': 'Yellow Zone',
                    'pos': LatLng(value.latitude, value.longitude),
                    'color': BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow,
                    ),
                    'c': Colors.yellow,
                  };
                  BlocProvider.of<FencesController>(context).setFences(x);
                  setState(() {
                    isLoading = false;
                    isSet = true;
                    position = value;
                  });
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const RedZone();
                  }));
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
            const SizedBox(
              height: 20,
            ),
            if (isLoading)
              const CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            if (!isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tap to set the yellow zone",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
