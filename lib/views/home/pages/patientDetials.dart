import 'package:care_taker/widgets/space.dart';

import '/exports/exports.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Space(space: 0.04),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 38),
              child: CircleAvatar(
                radius: 60,
                child: Image.asset("assets/001-profile.png"),
              ),
            ),
          ),
          const Space(space: 0.04),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text: "John Doe",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
        
          const Space(space: 0.04),
          const Text(
            "Patient Details",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
            const Divider(
            thickness: 1.4,
            indent: 20,
            endIndent: 2,
          ),
          const Space(space: 0.02),
          const Text(
            "Age: \t\t\t\t\t\t\t\t\t\t\t 25",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          const Text(""),
          const Space(space: 0.02),

        ],
      ),
    );
  }
}
