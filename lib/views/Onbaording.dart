// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter_svg/svg.dart';

import '/exports/exports.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, value: 0, duration: const Duration(milliseconds: 800));
    _controller?.forward();
     Future.delayed(const Duration(seconds: 3),(){
      Routes.routeUntil(context, Routes.home);
     });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomTopMoveAnimationView(
        animationController: _controller!,
        child:  SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                aspectRatio: 1.0,
                child: SvgPicture.asset("assets/caretaker.svg"),
              ),
                const CircularProgressIndicator.adaptive(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                const Text(
                  'Loading.......',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
