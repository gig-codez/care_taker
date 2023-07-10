import 'package:care_taker/controllers/FencesController.dart';
import 'package:flutter/services.dart';

import 'exports/exports.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
   SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// initialize notifications
  initializeNotifications();

  // await initializeLocationPermissions();
  //
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FencesController(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(14, 14, 67, 86),
          ),
          useMaterial3: true,
        ),
        initialRoute: Routes.onBoarding,
        routes: Routes.routes,
      ),
    ),
  );
}
