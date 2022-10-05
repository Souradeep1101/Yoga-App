import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_gate.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
          ()=>Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) =>
            const AuthGate(),
        ),
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.cyan[100] as Color,
              ],
            ),
            border: Border.all(
              color: Colors.cyan[100] as Color,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan[100] as Color,
                offset: const Offset(0,5),
                blurRadius: 6,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ]
        ),
        child: Center(
          child: Container(
            width: 288,
            height: 288,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_logo.png'),
                  fit: BoxFit.cover,
                )
            ),
          ),
        ),
      ),
    );
  }
}