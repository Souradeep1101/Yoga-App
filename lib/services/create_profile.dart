import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/screens/home.dart';
import 'package:yoga_app/services/email_verification.dart';
import 'package:yoga_app/services/realtime_database.dart';
import 'package:yoga_app/services/storage_service.dart';

class ProfileCreation extends StatefulWidget {

  const ProfileCreation({Key? key}) : super(key: key);

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {

  dynamic submitState = const Text('Submit');
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phoneNo = TextEditingController();
  final Storage storage = Storage();
  final storageRef = FirebaseStorage.instance.ref();
  String? imageUrl;
  //late final Image img;
  String? path;
  String? fileName;
  File? file;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Database databaseInstance = Database();
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Widget imageProfile(){
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null? null : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 28.0,),
            onTap: () {
              showModalBottomSheet(context: context, builder: (builder) => bottomSheet());
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
          const SizedBox(height: 20,),
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

  void takePhoto(ImageSource source) async{
    final pickedFile = await _picker.pickImage(source: source);
    setState((){_imageFile = pickedFile;});
    path = _imageFile!.path;
    fileName = _imageFile!.name;}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile', style: TextStyle(color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              imageProfile(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  autofocus: true,
                  decoration: const InputDecoration(
                    border:OutlineInputBorder(),
                    labelText: 'Enter your name',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter your name';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )
                  ),
                  fixedSize: MaterialStateProperty.all(const Size(240, 25)),
                ),
                onPressed: () async{
                  if (_formKey.currentState!.validate() && _imageFile != null) {
                    setState(() {submitState = const SizedBox(width: 20, height: 20,child: CircularProgressIndicator(color: Colors.white,));});
                    await storage.uploadFile(path!, fileName!, 'profile_img');
                    await FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
                    imageUrl = await storageRef.child("profile_img/$fileName").getDownloadURL();
                    await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
                    await FirebaseAuth.instance.currentUser!.reload();
                    await databaseInstance.writeData(
                        database,
                        '',
                        'users',
                        {
                          FirebaseAuth.instance.currentUser!.uid : {
                            'userName' : FirebaseAuth.instance.currentUser!.displayName,
                            'uid' : FirebaseAuth.instance.currentUser!.uid,
                            'email' : FirebaseAuth.instance.currentUser!.email,
                            'photoName' : fileName!,
                            'photoUrl' : FirebaseAuth.instance.currentUser!.photoURL,
                            'freemium' : true,
                          }
                        },
                        false, false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => (FirebaseAuth.instance.currentUser!.emailVerified != null || FirebaseAuth.instance.currentUser!.emailVerified != true ? const EmailVerify() : const Home())));
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Please enter your name and select a profile picture!')));
                  }
                },
                child: submitState,
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}

