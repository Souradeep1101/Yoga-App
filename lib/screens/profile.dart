import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:yoga_app/services/change_profile_image.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reload();
  }

  @override
  Widget build(BuildContext context) {
    reload();
    return ProfileScreen(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      providerConfigs: const [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId:
              '433378237444-s8c98nbslsl2f0c90v8ffno59ovhe801.apps.googleusercontent.com',
        ),
      ],
      avatarSize: 160,
      children: [
        MaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const ChangeProfileImage()));
          },
          child: const Text('Change Profile Image'),
        ),
      ],
    );
  }
}
