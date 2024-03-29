// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controllers/FencesController.dart';
import '/tools/index.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Example [Widget] showing the functionalities of the geolocator plugin
class GeolocatorWidget extends StatefulWidget {
  /// Creates a new GeolocatorWidget.
  const GeolocatorWidget({Key? key}) : super(key: key);

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<GeolocatorWidget> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
// list view controller
  final ScrollController _scrollController = ScrollController();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  @override
  void initState() {
    super.initState();
    initializeLocationPermissions();
    // update scroll position
  }

  PopupMenuButton _createActions() {
    return PopupMenuButton(
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case 1:
            _getLocationAccuracy();
            break;
          case 2:
            _requestTemporaryFullAccuracy();
            break;
          case 3:
            _openAppSettings();
            break;
          case 4:
            _openLocationSettings();
            break;
          case 5:
            setState(_positionItems.clear);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        if (Platform.isIOS)
          const PopupMenuItem(
            value: 1,
            child: Text("Get Location Accuracy"),
          ),
        if (Platform.isIOS)
          const PopupMenuItem(
            value: 2,
            child: Text("Request Temporary Full Accuracy"),
          ),
        const PopupMenuItem(
          value: 3,
          child: Text("Open App Settings"),
        ),
        if (Platform.isAndroid || Platform.isWindows)
          const PopupMenuItem(
            value: 4,
            child: Text("Open Location Settings"),
          ),
        const PopupMenuItem(
          value: 5,
          child: Text("Clear"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
            milliseconds: 900), // Adjust the duration as per your preference
        curve: Curves.easeInOutSine, // Adjust the curve as per your preference
      );
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('CareTaker\'s tracker view '),
          leading: Container(),
          actions: [
            _createActions(),
          ]),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<FencesController, Set<Map<String, dynamic>>>(
        listener: (context, state) {
          if (positionStreamStarted) {
            Future.delayed(const Duration(seconds: 3), () {
              for (var element in state) {
                _toggleServiceStatusStream(
                  lat: element['pos'].latitude,
                  long: element['pos'].longitude,
                );
              }
            });
          }
        },
        builder: (context, state) {
          // initialize geofencing
          return Scrollbar(
            interactive: true,
            radius: const Radius.circular(20),
            controller: _scrollController,
            trackVisibility: true,
            thickness: 10,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _positionItems.length,
              itemBuilder: (context, index) {
                final positionItem = _positionItems[index];

                if (positionItem.type == _PositionItemType.log) {
                  return ListTile(
                    leading: const Icon(Icons.info),
                    tileColor: Colors.blueGrey,
                    title: Text(positionItem.displayValue,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                        "$liveDistance meters away",
                        //positionItem.displayValue,
                        
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton:
          BlocConsumer<FencesController, Set<Map<String, dynamic>>>(
        listener: (context, state) {},
        builder: (context, state) {
          if (!positionStreamStarted) {
            Future.delayed(const Duration(seconds: 3), () {
              for (var element in state) {
                _toggleListening(
                    lat: element['pos'].latitude,
                    long: element['pos'].longitude,name: "${element['zone']}");
              }
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                
                    positionStreamStarted = !positionStreamStarted;
                  
                  // _toggleListening();
                },
                tooltip: (_positionStreamSubscription == null)
                    ? 'Start position updates'
                    : _positionStreamSubscription!.isPaused
                        ? 'Resume'
                        : 'Pause',
                backgroundColor: _determineButtonColor(),
                child: (_positionStreamSubscription == null ||
                        _positionStreamSubscription!.isPaused)
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause),
              ),
              sizedBox,
              // FloatingActionButton(
              //   onPressed: _getCurrentPosition,
              //   child: const Icon(Icons.my_location),
              // ),
              sizedBox,
              // FloatingActionButton(
              //   onPressed: _getLastKnownPosition,
              //   child: const Icon(Icons.bookmark),
              // ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();
    final position = await _geolocatorPlatform.getCurrentPosition();
    // double x = calculateDistance(position.latitude, position.longitude);
    // showNotification("Your have moved ${x.toInt()} ");
    _updatePositionList(
      _PositionItemType.position,
      position.toString(),
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  double liveDistance = 0.0;

  void _toggleServiceStatusStream({double lat = 0.0, double long = 0.0}) {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening(lat: lat, long: long);
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void _toggleListening({double? lat, double? long,String name = ""}) {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();

      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        Future.delayed(const Duration(seconds: 3), () {
          // startGeofencing();
          double x = calculateDistance(
              position.latitude, position.longitude, lat!, long!);
          setState(() {
            liveDistance = x;
          });
          showNotification("Your have moved ${x.toInt()} to $name");
        });

        _updatePositionList(
          _PositionItemType.position,
          position.toString(),
        );
      });

      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
