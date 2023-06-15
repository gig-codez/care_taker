// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:care_taker/views/home/pages/patientDetials.dart';
import 'package:care_taker/widgets/space.dart';

import '/views/home/pages/widgets/mapWidget.dart';

import '/exports/exports.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return const MapUiBody();
  }
}

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapUiBody extends StatefulWidget {
  const MapUiBody();

  @override
  State<StatefulWidget> createState() => MapUiBodyState();
}

class MapUiBodyState extends State<MapUiBody> {
  MapUiBodyState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 11.0,
  );

  MapboxMapController? mapController;
  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  bool _compassEnabled = true;
  bool _mapExpanded = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  int _styleStringIndex = 0;
  // Style string can a reference to a local or remote resources.
  // On Android the raw JSON can also be passed via a styleString, on iOS this is not supported.
  List<String> _styleStrings = [
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.SATELLITE,
    "assets/style.json"
  ];
  List<String> _styleStringLabels = [
    "MAPBOX_STREETS",
    "SATELLITE",
    "LOCAL_ASSET"
  ];
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool? _doubleClickToZoomEnabled;
  bool _tiltGesturesEnabled = true;
  bool _zoomGesturesEnabled = true;
  bool _myLocationEnabled = true;
  bool _telemetryEnabled = true;
  MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.None;
  List<Object>? _featureQueryFilter;
  Fill? _selectedFill;

  @override
  void initState() {
    super.initState();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    final position = mapController!.cameraPosition;
    if (position != null) _position = position;
    _isMoving = mapController!.isCameraMoving;
  }

  @override
  void dispose() {
    mapController?.removeListener(_onMapChanged);
    super.dispose();
  }

  Widget _myLocationTrackingModeCycler() {
    final MyLocationTrackingMode nextType = MyLocationTrackingMode.values[
        (_myLocationTrackingMode.index + 1) %
            MyLocationTrackingMode.values.length];
    return TextButton(
      child: Text('change to $nextType'),
      onPressed: () {
        setState(() {
          _myLocationTrackingMode = nextType;
        });
      },
    );
  }

  Widget _queryFilterToggler() {
    return TextButton(
      child: Text(
          'filter zoo on click ${_featureQueryFilter == null ? 'disabled' : 'enabled'}'),
      onPressed: () {
        setState(() {
          if (_featureQueryFilter == null) {
            _featureQueryFilter = [
              "==",
              ["get", "type"],
              "zoo"
            ];
          } else {
            _featureQueryFilter = null;
          }
        });
      },
    );
  }

  Widget _mapSizeToggler() {
    return TextButton(
      child: Text('${_mapExpanded ? 'shrink' : 'expand'} map'),
      onPressed: () {
        setState(() {
          _mapExpanded = !_mapExpanded;
        });
      },
    );
  }

  Widget _compassToggler() {
    return TextButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compasss'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _latLngBoundsToggler() {
    return TextButton(
      child: Text(
        _cameraTargetBounds.bounds == null
            ? 'bound camera target'
            : 'release camera target',
      ),
      onPressed: () {
        setState(() {
          _cameraTargetBounds = _cameraTargetBounds.bounds == null
              ? CameraTargetBounds(sydneyBounds)
              : CameraTargetBounds.unbounded;
        });
      },
    );
  }

  Widget _zoomBoundsToggler() {
    return TextButton(
      child: Text(_minMaxZoomPreference.minZoom == null
          ? 'bound zoom'
          : 'release zoom'),
      onPressed: () {
        setState(() {
          _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
              ? const MinMaxZoomPreference(12.0, 16.0)
              : MinMaxZoomPreference.unbounded;
        });
      },
    );
  }

  Widget _setStyleToSatellite() {
    return TextButton(
      child: Text(
          'change map style to ${_styleStringLabels[(_styleStringIndex + 1) % _styleStringLabels.length]}'),
      onPressed: () {
        setState(() {
          _styleStringIndex = (_styleStringIndex + 1) % _styleStrings.length;
        });
      },
    );
  }

  Widget _rotateToggler() {
    return TextButton(
      child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
      onPressed: () {
        setState(() {
          _rotateGesturesEnabled = !_rotateGesturesEnabled;
        });
      },
    );
  }

  Widget _scrollToggler() {
    return TextButton(
      child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
      onPressed: () {
        setState(() {
          _scrollGesturesEnabled = !_scrollGesturesEnabled;
        });
      },
    );
  }

  Widget _doubleClickToZoomToggler() {
    final stateInfo = _doubleClickToZoomEnabled == null
        ? "disable"
        : _doubleClickToZoomEnabled!
            ? 'unset'
            : 'enable';
    return TextButton(
      child: Text('$stateInfo double click to zoom'),
      onPressed: () {
        setState(() {
          if (_doubleClickToZoomEnabled == null) {
            _doubleClickToZoomEnabled = false;
          } else if (!_doubleClickToZoomEnabled!) {
            _doubleClickToZoomEnabled = true;
          } else {
            _doubleClickToZoomEnabled = null;
          }
        });
      },
    );
  }

  Widget _tiltToggler() {
    return TextButton(
      child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
      onPressed: () {
        setState(() {
          _tiltGesturesEnabled = !_tiltGesturesEnabled;
        });
      },
    );
  }

  Widget _zoomToggler() {
    return TextButton(
      child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
      onPressed: () {
        setState(() {
          _zoomGesturesEnabled = !_zoomGesturesEnabled;
        });
      },
    );
  }

  Widget _myLocationToggler() {
    return TextButton(
      child: Text('${_myLocationEnabled ? 'disable' : 'enable'} my location'),
      onPressed: () {
        setState(() {
          _myLocationEnabled = !_myLocationEnabled;
        });
      },
    );
  }

  Widget _telemetryToggler() {
    return TextButton(
      child: Text('${_telemetryEnabled ? 'disable' : 'enable'} telemetry'),
      onPressed: () {
        setState(() {
          _telemetryEnabled = !_telemetryEnabled;
        });
        mapController?.setTelemetryEnabled(_telemetryEnabled);
      },
    );
  }

  Widget _visibleRegionGetter() {
    return TextButton(
      child: const Text('get currently visible region'),
      onPressed: () async {
        var result = await mapController!.getVisibleRegion();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "SW: ${result.southwest.toString()} NE: ${result.northeast.toString()}"),
        ));
      },
    );
  }

  _clearFill() {
    if (_selectedFill != null) {
      mapController!.removeFill(_selectedFill!);
      setState(() {
        _selectedFill = null;
      });
    }
  }

  _drawFill(List<dynamic> features) async {
    Map<String, dynamic>? feature =
        features.firstWhereOrNull((f) => f['geometry']['type'] == 'Polygon');

    if (feature != null) {
      List<List<LatLng>> geometry = feature['geometry']['coordinates']
          .map(
              (ll) => ll.map((l) => LatLng(l[1], l[0])).toList().cast<LatLng>())
          .toList()
          .cast<List<LatLng>>();
      Fill fill = await mapController!.addFill(FillOptions(
        geometry: geometry,
        fillColor: "#FF0000",
        fillOutlineColor: "#FF0000",
        fillOpacity: 0.6,
      ));
      setState(() {
        _selectedFill = fill;
      });
    }
  }

//  top widget
  Widget topWidget() {
    return Container(
      height: MediaQuery.of(context).size.width / 9,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 9, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          IconButton(
            onPressed: () => Routes.push(
              context,
              const PatientDetails(),
            ),
            icon: const CircleAvatar(
              child: Icon(Icons.person_3_rounded),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken:
          "sk.eyJ1IjoibXVnYW1iYTI1NiIsImEiOiJjbGlrOWFjdGIwMHh0M3FxbTF2bDJ2cXR6In0.JOUkusZ5PXHS7imtXwYAXA",
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleStrings[_styleStringIndex],
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      doubleClickZoomEnabled: _doubleClickToZoomEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        print(
            "Map click: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        print("Filter $_featureQueryFilter");
        List features = await mapController!
            .queryRenderedFeatures(point, [], _featureQueryFilter);
        print('# features: ${features.length}');
        _clearFill();
        if (features.isEmpty && _featureQueryFilter != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('QueryRenderedFeatures: No features found!')));
        } else if (features.isNotEmpty) {
          _drawFill(features);
        }
      },
      onMapLongClick: (point, latLng) async {
        print(
            "Map long press: ${point.x},${point.y}   ${latLng.latitude}/${latLng.longitude}");
        Point convertedPoint = await mapController!.toScreenLocation(latLng);
        LatLng convertedLatLng = await mapController!.toLatLng(point);
        print(
            "Map long press converted: ${convertedPoint.x},${convertedPoint.y}   ${convertedLatLng.latitude}/${convertedLatLng.longitude}");
        double metersPerPixel =
            await mapController!.getMetersPerPixelAtLatitude(latLng.latitude);

        print(
            "Map long press The distance measured in meters at latitude ${latLng.latitude} is $metersPerPixel m");

        List features =
            await mapController!.queryRenderedFeatures(point, [], null);
        if (features.length > 0) {
          print(features[0]);
        }
      },
      onCameraTrackingDismissed: () {
        this.setState(() {
          _myLocationTrackingMode = MyLocationTrackingMode.None;
        });
      },
      onUserLocationUpdated: (location) {
        print(
            "new location: ${location.position}, alt.: ${location.altitude}, bearing: ${location.bearing}, speed: ${location.speed}, horiz. accuracy: ${location.horizontalAccuracy}, vert. accuracy: ${location.verticalAccuracy}");
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    if (mapController != null) {
      listViewChildren.addAll(
        <Widget>[
          Text('camera bearing: ${_position.bearing}'),
          Text('camera target: ${_position.target.latitude.toStringAsFixed(4)},'
              '${_position.target.longitude.toStringAsFixed(4)}'),
          Text('camera zoom: ${_position.zoom}'),
          Text('camera tilt: ${_position.tilt}'),
          Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
          _mapSizeToggler(),
          _queryFilterToggler(),
          _compassToggler(),
          _myLocationTrackingModeCycler(),
          _latLngBoundsToggler(),
          _setStyleToSatellite(),
          _zoomBoundsToggler(),
          _rotateToggler(),
          _scrollToggler(),
          _doubleClickToZoomToggler(),
          _tiltToggler(),
          _zoomToggler(),
          _myLocationToggler(),
          _telemetryToggler(),
          _visibleRegionGetter(),
        ],
      );
    }
    return Stack(
      children: [
        mapboxMap,
        Positioned(
          bottom: 5,
          right: 10,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: null,
                onPressed: _clearFill,
                child: const Icon(Icons.my_location_rounded),
              ),
              const Space(space: 0.05),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                            onClosing: () {},
                            builder: (context) {
                              return ListView(
                                children: [...listViewChildren],
                              );
                            });
                      });
                },
                child: const Icon(Icons.directions),
              ),
            ],
          ),
        ),
        topWidget(),
      ],
    );
  }

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController!.addListener(_onMapChanged);
    _extractMapInfo();

    mapController!.getTelemetryEnabled().then((isEnabled) => setState(() {
          _telemetryEnabled = isEnabled;
        }));
  }
}
