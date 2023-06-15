import '/exports/exports.dart';

class MapViewWidget extends StatefulWidget {
  final MapboxMapController mapController;
  const MapViewWidget({super.key, required this.mapController});

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.cameraswitch_rounded),
          ),
          onTap: () {
            widget.mapController
                .animateCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      bearing: 270.0,
                      target: LatLng(51.5160895, -0.1294527),
                      tilt: 30.0,
                      zoom: 17.0,
                    ),
                  ),
                )
                .then((result) => print(
                    "widget.mapControlleranimateCamera() returned $result"));
                    Routes.pop(context);
          },
          title: const Text(
            'Camera Position',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.location_searching_rounded),
          ),
          onTap: () {

            widget.mapController
                .animateCamera(
                  CameraUpdate.newLatLng(
                    const LatLng(56.1725505, 10.1850512),
                  ),
                )
                .then((result) => print(
                    "widget.mapControlleranimateCamera() returned $result"));
                    Routes.pop(context);
          },
          title: const Text(
            'New LatLang',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.add),
          ),
          onTap: () {
            widget.mapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: const LatLng(-38.483935, 113.248673),
                  northeast: const LatLng(-8.982446, 153.823821),
                ),
                left: 10,
                top: 5,
                bottom: 25,
              ),
            );
          },
          title: const Text('New LatLng Bounds',
              style: TextStyle(color: Colors.white)),
        ),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.add),
          ),
          onTap: () {
            widget.mapController.animateCamera(
              CameraUpdate.newLatLngZoom(
                const LatLng(37.4231613, -122.087159),
                11.0,
              ),
            );
            Routes.pop(context);
          },
          title: const Text(
            'New LatLng Zoom',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.threed_rotation_outlined),
          ),
          onTap: () {
            widget.mapController.animateCamera(
              CameraUpdate.scrollBy(150.0, -225.0),
              
            );
            Routes.pop(context);
          },
          title: const Text('ScrollBy', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
