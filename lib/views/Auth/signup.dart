import 'package:care_taker/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_svg/flutter_svg.dart';

import '/exports/exports.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final providers = [
    EmailAuthProvider(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData? const HomePageView():  SignInScreen(
            providers: providers,
            headerBuilder: (context, constraints, x) {
              return AspectRatio(
                aspectRatio: 1.0,
                child: SvgPicture.asset("assets/caretaker.svg"),
              );
            },
            actions: [
              AuthStateChangeAction<SignedIn>(
                (context, state) => Routes.named(context, Routes.home),
              ),
            ],
          );
        });
  }
}
