import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:metube/features/auth/pesentation/pages/signup_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SignupPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/lottie/splash.json"),
          ),
          Text("Metube", style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
    );
  }
}
