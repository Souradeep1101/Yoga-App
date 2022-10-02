import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/screens/home.dart';
import 'auth_gate.dart';

User? user = getUser();
bool isEmailVerified = false;
Timer? timer;

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isEmailVerified != true) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified == true) {
      return const Home();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Verify Email!',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.cyan[100],
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SpinKitWave(
                  color: Colors.black,
                ),
                Text(
                    'In order to use this app you need to verify your email address, we have send you a verification link. Click on the link to verify!'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error! Verifying email')));
    }
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified == true) {
      timer?.cancel();
    }
  }
}
