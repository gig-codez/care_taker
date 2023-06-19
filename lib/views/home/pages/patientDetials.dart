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
      body: Stack(
        children: [
          Positioned(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12, left: 50),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Space(space: 0.04),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade200,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.35,
                    child: const Column(
                      children: [
                        ListTile(
                          title: Text(
                            "Age",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: Text(
                            "40 yrs",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Divider(),
                         ListTile(
                          title: Text(
                            "Condition",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          trailing: Text(
                            "Alzemergia",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Space(space: 0.04),
                ElevatedButton(onPressed: (){}, child: const Text("View History"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
