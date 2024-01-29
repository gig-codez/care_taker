import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart' as G;

import 'package:intl/intl.dart';
// import 'package:location/location.dart' as l;
import '../widgets/space.dart';
import '/exports/exports.dart';
void showMessage(
    {String type = 'info',
    String? msg,
    bool float = false,
    required BuildContext context,
    double opacity = 1,
    int duration = 5,
    Animation<double>? animation}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: float ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      content: Text(msg ?? ''),
      backgroundColor: type == 'info'
          ? Colors.lightBlue
          : type == 'warning'
              ? Colors.orange[800]!.withOpacity(opacity)
              : type == 'danger'
                  ? Colors.red[800]!.withOpacity(opacity)
                  : type == 'success'
                      ? const Color.fromARGB(255, 2, 104, 7)
                          .withOpacity(opacity)
                      : Colors.grey[600]!.withOpacity(opacity),
      duration: Duration(seconds: duration),
    ),
  );
}

/// show progress widget
void showProgress(BuildContext context, {String? text = 'Task'}) {
  showCupertinoModalPopup(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    context: context,
    builder: (context) => BottomSheet(
      enableDrag: false,
      backgroundColor: Colors.black12,
      onClosing: () {},
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitDualRing(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).primaryColor),
          const Space(
            space: 0.03,
          ),
          Text(
            "$text..",
            style: const TextStyle(color: Colors.black,fontSize: 20),
          )
        ],
      ),
    ),
  );
}


String formatNumberWithCommas(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
//  date format
String formatDate(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}
//  get current location from geolocator

// initialization for Geofence
final G.Geolocator geolocator = G.Geolocator();

// Define the geofence zones
// final Map<String, LatLng> geofenceZones = {
//   'Green Zone': const LatLng(0.7749, 37.4194),
//   'Yellow Zone': const LatLng(0.7833, 37.4167),
//   'Blue Zone': const LatLng(0.7953, 37.3934),
// };
// computing distance between two points
double calculateDistance(double startLatitude,
  double startLongitude,double endLatitude,double endLongitude
  ) {
  final distanceInMeters = G.Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
  return distanceInMeters;
}

// logic to identify change of zones
 StreamSubscription<G.Position>? positionStream;

void startGeofencing(Map<String, LatLng> geofenceZones) {
  positionStream = G.Geolocator.getPositionStream().listen((G.Position position) {
    final LatLng currentPosition = LatLng(position.latitude, position.longitude);

    // Check if the current position is within any geofence zone
    for (final entry in geofenceZones.entries) {
      final String zoneName = entry.key;
      final LatLng zoneCoordinates = entry.value;
      final double distance = G.Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        zoneCoordinates.latitude,
        zoneCoordinates.longitude,
      );

      // Define the radius of the geofence zone (in meters)
      const double geofenceRadius = 100.0;
      if (distance <= geofenceRadius) {
        showNotification('Entered $zoneName');
      }
    }
  });
}
  final G.GeolocatorPlatform _geolocatorPlatform = G.GeolocatorPlatform.instance;
  //  initialize location permissions

 Future<bool> initializeLocationPermissions() async {
  G.LocationPermission  permission;
      permission = await _geolocatorPlatform.checkPermission();
    if (permission == G.LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == G.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      
      permission = await _geolocatorPlatform.requestPermission();
        return false;
      }
    }
    return true;
}

// initialize app notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// Define notification channels
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'geofence_channel',
  'Geofence Notifications',
  importance: Importance.high,
  playSound: true,
);
// ios notification channel
void initializeNotifications() {
//  initialize both android and ios notifications
  const InitializationSettings initializationSettings =
      InitializationSettings(android: AndroidInitializationSettings('android12splash'),iOS: DarwinInitializationSettings());
      // 
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  //  request permission for android and ios notifications
 
flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    // ios permission
flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
// function to handle notification for change of zones
void showNotification(String message) async {
  // android notification specifics
   AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'geofence_notification',
    'Geofence Notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );
  //  ios specifics
  const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

   NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iosPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Patient\'s Location',
    message,
    platformChannelSpecifics,
  );
}



String getElapsedTime(Timestamp timestamp) {
  final currentTime = DateTime.now();
  final timestampTime = timestamp.toDate();

  final difference = currentTime.difference(timestampTime);
  final minutes = difference.inMinutes;
  final hours = difference.inHours;
  final days = difference.inDays;

  if (days > 0) {
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  } else if (minutes > 0) {
    return '$minutes minute${minutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}