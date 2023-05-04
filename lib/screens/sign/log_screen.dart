import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Image.asset('assets/images/elderly2.jpg',
          opacity: const AlwaysStoppedAnimation(0.6),
          width: size.width,
          height: size.height,
          fit: BoxFit.fill,
        ),
        Positioned(
          bottom: size.height * 0.05,
          right: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: const Text('LogIn'),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              SizedBox(
                width: size.width,
                height: size.height * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const SignScreen()));
                  },
                  child: const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
