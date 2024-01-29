// ignore_for_file: use_build_context_synchronously
import 'dart:async';

// import 'package:location/location.dart' as l;

import 'package:care_taker/controllers/FencesController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// import '/controllers/LocationController.dart';
import '/exports/exports.dart';

const String androidApiKey = "AIzaSyDIIUClw731TnLo1JLVZi_Yxw59l11g3b0";
const String iOSApiKey = "AIzaSyBYnoDH981M_gkl8vYb_gQxpb0-9ZinMuA";

class MapUIView extends StatefulWidget {
  const MapUIView({super.key});

  @override
  State<MapUIView> createState() => MapUIViewState();
}

class MapUIViewState extends State<MapUIView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // Location location = Location();
  @override
  void initState() {
    super.initState();
    // context.read<LocationController>().updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    // invoke determinePosition() from location controller
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        body: BlocConsumer<FencesController, Set<Map<String, dynamic>>>(
          listener: (context, state) {
            if(state.isEmpty){
                showMessage(context: context,msg: "No Fences Found",type: "danger");
            }
          },
          builder: (context, state) {
            return GoogleMap(
              mapType: MapType.normal,
              markers: state.map((e) => Marker(
                    markerId: MarkerId(e['zone']),
                    position: e['pos'],
                    icon: e['color'],
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            color: e['c'],
                            child: Center(
                              child: Text(
                                e['zone'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )).toSet(),
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.2475137, 32.5451041),
                zoom: 49.151926040649414,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          },
        ),
      panel: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
        ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            const SizedBox(height: 10,),
            const Text("Fences",style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 10,),
            BlocBuilder<FencesController, Set<Map<String, dynamic>>>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.elementAt(index)['zone']),
                        subtitle: Text(state.elementAt(index)['pos'].toString()),
                        trailing: IconButton(
                          onPressed: (){
                            // BlocProvider.of<FencesController>(context).removeFence(state.elementAt(index));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      )
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
  }
}
