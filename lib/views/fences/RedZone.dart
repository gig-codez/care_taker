// ignore_for_file: file_names

import 'dart:collection';

import 'package:care_taker/views/fences/Fences.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/FencesController.dart';
import '../../controllers/MainController.dart';
import '../../exports/exports.dart';
import '../home/pages/map.dart';

class RedZone extends StatefulWidget {
  const RedZone({super.key});

  @override
  State<RedZone> createState() => _RedZoneState();
}

class _RedZoneState extends State<RedZone> {
  Position? position;
  MainController? cntl;
  bool isSet = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // cntl = Provider.of<MainController>(context);
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                GeolocatorPlatform.instance.getCurrentPosition().then((value) {
                  BlocProvider.of<FencesController>(context).setFences({
                    'zone': 'Red Zone',
                    'pos': LatLng(value.latitude, value.longitude),
                    'color': BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                    'c': Colors.red,
                  });

                  setState(() {
                    isSet = true;
                    isLoading = false;
                    position = value;
                  });
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomePageView();
                      },
                    ),
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
                  "Tap to set the red zone",
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
