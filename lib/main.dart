import 'package:firebase_auth/firebase_auth.dart';
import 'exports/exports.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
//  initializing firebase options
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/onboarding' : '/home',
      routes:Routes.routes ,
    ),
  );

  // after initialization remove the splash.
  FlutterNativeSplash.remove();
}
