import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

import '../../provider/my_provider.dart';

import '../home/home_screen.dart';
import '../sign/log_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<MyPro>(context, listen: false).getSavedSign());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<MyPro>(
      builder: (ctx, val, _) {
        return AnimatedSplashScreen(
          duration: 800,
          splashIconSize: 250,
          splash: Lottie.asset(
              'assets/lottie/splash.json',
              width: size.width * 0.5,
              height: size.height * 0.5,
              fit: BoxFit.contain
          ),
          nextScreen: val.isSign? const HomeScreen() : const LogScreen(),
          splashTransition: SplashTransition.fadeTransition,
        );
      }
    );
  }
}