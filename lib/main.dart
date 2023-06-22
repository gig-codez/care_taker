import '/controllers/LocationController.dart';

import 'controllers/MainController.dart';
import 'exports/exports.dart';
import 'firebase_options.dart';
void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
// initialize notifications
 initializeNotifications();
 bool checkPermission = await initializeLocationPermissions();
// initialize geofencing
if (checkPermission == true) {
  startGeofencing();
} else if (checkPermission == false) {
  // show error message
  print('permission denied');
}
 //
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create:(x) => LocationController()),
        ChangeNotifierProvider(create: (x) => MainController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(14, 14, 67, 86)),
          useMaterial3: true,
        ),
        initialRoute: Routes.onBoarding ,
        routes:Routes.routes ,
      ),
    ),
  );
}
