import 'package:care_taker/exports/exports.dart';
import 'package:flutter/material.dart';

class Doctors extends StatefulWidget {
  const Doctors({super.key});

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('care-taker').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: const Text('Doctor Name'),
                subtitle: const Text('Doctor Speciality'),
                trailing:
                    IconButton(icon: const Icon(Icons.call), onPressed: () {}),
              );
            },
          );
        },
      ),
    );
  }
}
