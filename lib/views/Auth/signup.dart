// ignore_for_file: use_build_context_synchronously

import '/views/Auth/widgets/CommonInput.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/exports/exports.dart';
import 'EmailVerificationView.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  static Future<User?> signUp(var data, {required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data['email'], password: data['password']);
      // save the rest of the data in firestore
      await FirebaseFirestore.instance.collection("care-taker").add(data);
      //  end of firestore
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
                  "Create account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _nameController,
                    hintText: "Name",
                    textInputAction: TextInputAction.next),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _phoneController,
                    hintText: "Phone number",
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.phone),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _emailController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _passwordController,
                    hintText: "Password",
                    textInputAction: TextInputAction.next,
                    password: true),
                const SizedBox(
                  height: 20,
                ),
                CommonInput(
                    controller: _confirmController,
                    hintText: "Confirm Password",
                    textInputAction: TextInputAction.done,
                    password: true),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _isLoading ? (){}: () async {
                    // Validate returns true if the form is valid,
                    // or false otherwise
                    if (_nameController.text.isEmpty ||
                        _phoneController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'Please fill all the fields.',
                        )),
                      );
                    } else if (_passwordController.text !=
                        _confirmController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'The passwords do not match.',
                        )),
                      );
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      // captured data
                      var _data = {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text
                      };

                      await signUp(_data, context: context);
                      if (FirebaseAuth.instance.currentUser != null) {
                        Routes.push(context, const EmailVerificationView());
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 17),
                        ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 17),
                    ),
                    TextButton(
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        Routes.named(context, Routes.login);
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
