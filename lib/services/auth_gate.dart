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
      // If the user is already signed-in, use it as initial data
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
              AppleProviderConfiguration(),
              // GoogleProviderConfiguration(
              //   clientId: '433378237444-s8c98nbslsl2f0c90v8ffno59ovhe801.apps.googleusercontent.com',
              // ),
              //PhoneProviderConfiguration(),
            ],
          );
        }
        user = FirebaseAuth.instance.currentUser;
        // Render your application if authenticated
        print('${user} email');
        // return user != null ? (user!.displayName != null && user!.photoURL != null && user!.emailVerified != null ? Home() : (user!.displayName != null && user!.photoURL != null ? ProfileCreation() : (user!.emailVerified != null || user!.emailVerified != true ?EmailVerify() : Home()))): Text('Please reinstall the app!');
        if(user != null) {
          if(user?.displayName != null && user?.photoURL != null && (user?.emailVerified != null && user?.emailVerified != false) ) {
            return Home();
          }
          else {
            if(user?.displayName == null && user?.photoURL == null && (user?.emailVerified == null || user?.emailVerified != true)) {
              return ProfileCreation();
            }
            else return EmailVerify();
          }
        }
        else return ErrorScreen();
        //return Home();
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


