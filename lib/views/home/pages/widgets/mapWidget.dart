import 'package:care_taker/exports/exports.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../controllers/mainController.dart';

class PanelData extends StatefulWidget {
  const PanelData({super.key});

  @override
  State<PanelData> createState() => _PanelDataState();
}

class _PanelDataState extends State<PanelData> {
  final List<Map<String, dynamic>> pos = [
    {'type': 'Map View', 'icon': Icons.map_rounded, 'mapType': MapType.normal},
    {
      'type': 'Satellite View',
      'icon': Icons.satellite,
      'mapType': MapType.satellite
    },
    {'type': 'Terrain View', 'icon': Icons.terrain, 'mapType': MapType.terrain}
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            "Select your appropriate view",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ChangeNotifierProvider(
          create: ( context) => MainController(),
          builder: (c,x) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              pos.length,
              (index) => InkWell(
                onTap: () {
                  Provider.of<MainController>(context)
                 
                      .setMapType(pos[index]['mapType']);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 30,
                      child: Icon(
                        pos[index]['icon'],
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${pos[index]['type']}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
