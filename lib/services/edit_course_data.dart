import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yoga_app/services/realtime_database.dart';
import 'package:yoga_app/services/storage_service.dart';
import '../screens/file_upload.dart';

class EditCourseData extends StatefulWidget {
  String? courseName;
  EditCourseData({Key? key, required this.courseName}) : super(key: key);

  @override
  State<EditCourseData> createState() => _EditCourseDataState();
}

class _EditCourseDataState extends State<EditCourseData> {
  dynamic submitState = const Text('Submit');
  String? courseName;
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  bool freemium = false;
  final Storage storage = Storage();
  final storageRef = FirebaseStorage.instance.ref();
  String? imageUrl;
  String? videoUrl;
  String? path;
  String? fileName;
  File? file;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Database databaseInstance = Database();
  FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  Widget imageProfile() {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: _imageFile == null
                  ? const AssetImage('assets/white_img_background.jpg')
                  : FileImage(File(_imageFile!.path)) as ImageProvider<Object>,
            ),
          ),
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
          'Editing course',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                imageProfile(),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter the Title';
                      }
                      return null;
                    },
                  ),
                ),
                FilterChip(
                  label: const Text('Freemium'),
                  onSelected: (bool value) {
                    setState(() {
                      freemium = value;
                    });
                  },
                  selected: freemium,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    fixedSize: MaterialStateProperty.all(const Size(240, 25)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        _imageFile != null) {
                      setState(() {
                        submitState = const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                      });
                      await storage.uploadFile(
                          path!, fileName!, 'thumbnails/course_thumbnails');
                      imageUrl = await storageRef
                          .child("thumbnails/course_thumbnails/$fileName")
                          .getDownloadURL();
                      await databaseInstance.writeData(
                          database,
                          '',
                          'courses/${widget.courseName}',
                          {
                            'title': title.text,
                            'freemium': freemium,
                            'thumbnail': imageUrl,
                          },
                          false,
                          false);
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter the required details!')));
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
