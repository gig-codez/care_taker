// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geofence_flutter/geofence_flutter.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, this.title = 'Notifications'})
      : super(key: key);

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off_outlined,
              size: 30,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "No new notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            )
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
