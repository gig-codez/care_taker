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
    return SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) => Routes.named(context, Routes.home),
        ),
      ],
    );
  }
}
