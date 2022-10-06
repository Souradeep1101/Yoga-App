import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yoga_app/services/create_profile.dart';
import 'package:yoga_app/services/email_verification.dart';
import 'package:yoga_app/services/error_screen.dart';

import '../screens/home.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
User? user;

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            headerBuilder: (context, constraints, _) {
            return ClipRect(
              child: Container(width: 500, height: 500, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/splash_logo.png'),))),

            );
          },
            providerConfigs: const [
              EmailProviderConfiguration(),
            ],
          );
        }
        user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (user?.displayName != null &&
              user?.photoURL != null &&
              (user?.emailVerified != null && user?.emailVerified != false)) {
            return const Home();
          } else {
            if (user?.displayName == null &&
                user?.photoURL == null &&
                (user?.emailVerified == null || user?.emailVerified != true)) {
              return const ProfileCreation();
            } else {
              return const EmailVerify();
            }
          }
        } else {
          return const ErrorScreen();
        }
      },
    );
  }
}

User? getUser() {
  return user;
}

String getUID() {
  return user!.uid;
}

bool userIsRegistered() {
  return false;
}
