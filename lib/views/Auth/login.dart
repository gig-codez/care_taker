// ignore_for_file: use_build_context_synchronously

import '/views/Auth/widgets/CommonInput.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/exports/exports.dart';
import 'EmailVerificationView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static Future<User?> _login(
      {required String userEmail,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Image.asset("assets/dr.png"),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                  controller: _emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _passwordController,
                    hintText: "Password",
                    textInputAction: TextInputAction.done,
                    password: true),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
               
                    
                  ElevatedButton(
                        onPressed: _isLoading ?(){}: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await  _login(
                              userEmail: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          if (FirebaseAuth.instance.currentUser != null) {
                            Routes.named(context, Routes.home);
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: _isLoading ? const CircularProgressIndicator.adaptive() : const Text(
                          'Login',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        Routes.named(context, Routes.signUp);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
