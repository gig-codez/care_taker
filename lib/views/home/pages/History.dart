// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geofence_flutter/geofence_flutter.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key,  this.title = 'Notifications'}) : super(key: key);

  final String title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  StreamSubscription<GeofenceEvent>? geofenceEventStream;
  String geofenceEvent = '';

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController radiusController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Geofence Event: " + geofenceEvent,
            ),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter pointed latitude'),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter pointed longitude'),
            ),
            TextField(
              controller: radiusController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Enter radius meter'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text("Start"),
                  onPressed: () async {
                    print("start");
                    await Geofence.startGeofenceService(
                        pointedLatitude: latitudeController.text,
                        pointedLongitude: longitudeController.text,
                        radiusMeter: radiusController.text,
                        eventPeriodInSeconds: 10);
                    geofenceEventStream ??= Geofence.getGeofenceStream()
                          ?.listen((GeofenceEvent event) {
                        if (kDebugMode) {
                          print(event.toString());
                        }
                        setState(() {
                          geofenceEvent = event.toString();
                        });
                      });
                  },
                ),
                SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  child: Text("Stop"),
                  onPressed: () {
                    print("stop");
                    Geofence.stopGeofenceService();
                    geofenceEventStream?.cancel();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();

    super.dispose();
  }
}