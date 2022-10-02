import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/services/realtime_database.dart';
import 'package:yoga_app/services/storage_service.dart';

class ChangeProfileImage extends StatefulWidget {
  const ChangeProfileImage({Key? key}) : super(key: key);

  @override
  State<ChangeProfileImage> createState() => _ChangeProfileImageState();
}

class _ChangeProfileImageState extends State<ChangeProfileImage> {
  dynamic submitState = const Text('Submit');
  final Storage storage = Storage();
  final storageRef = FirebaseStorage.instance.ref();
  String? imageUrl;
  String? path;
  String? fileName;
  File? file;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Database databaseInstance = Database();
  FirebaseDatabase database = FirebaseDatabase.instance;

  Widget imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage:
              _imageFile == null ? null : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.black,
              size: 28.0,
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (builder) => bottomSheet());
            },
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
    path = _imageFile!.path;
    fileName = _imageFile!.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Profile Picture',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imageProfile(),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                    fixedSize: MaterialStateProperty.all(const Size(240, 25)),
                  ),
                  onPressed: () async {
                    if (_imageFile != null) {
                      setState(() {
                        submitState = const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                      });
                      final dataRef = await database
                          .ref()
                          .child(
                              'users/${await FirebaseAuth.instance.currentUser!.uid}/photoName')
                          .get();
                      final oldProfileImg = dataRef.value.toString();
                      await storageRef
                          .child("profile_img/$oldProfileImg")
                          .delete();
                      await storage.uploadFile(path!, fileName!, 'profile_img');
                      imageUrl = await storageRef
                          .child("profile_img/$fileName")
                          .getDownloadURL();
                      await FirebaseAuth.instance.currentUser!
                          .updatePhotoURL(imageUrl);
                      await FirebaseAuth.instance.currentUser!.reload();
                      await databaseInstance.writeData(
                          database,
                          '',
                          'users/${await FirebaseAuth.instance.currentUser!.uid}',
                          {
                            'photoUrl':
                                FirebaseAuth.instance.currentUser!.photoURL,
                            'photoName': fileName,
                          },
                          false,
                          false);
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Please enter your name and select a profile picture!')));
                    }
                  },
                  child: submitState,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
