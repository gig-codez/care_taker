import 'package:care_taker/controllers/FencesController.dart';
import 'package:care_taker/exports/exports.dart';

class Fences extends StatefulWidget {
  const Fences({super.key});

  @override
  State<Fences> createState() => _FencesState();
}

class _FencesState extends State<Fences> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocConsumer<FencesController,Set<Map<String,dynamic>>>(
        listener: (context,fences) {
          
        },
        builder: (context,fences) {
          return  Column(
            children: fences.map((e) {
              return  ListTile(
                title: Text(e['zone']),
                subtitle: Text(e['pos'].toString()),
                trailing: IconButton(
                  onPressed: () {
                    
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            }).toList()
          );
        }
      ),
    );
  }
}
