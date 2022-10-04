import 'package:flutter/material.dart';
import 'package:yoga_app/screens/view_courses.dart';
import 'package:yoga_app/services/create_course.dart';

class UploadType extends StatefulWidget {
  const UploadType({Key? key}) : super(key: key);

  @override
  State<UploadType> createState() => _UploadTypeState();
}

class _UploadTypeState extends State<UploadType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(
              child: Text(
            'Lets get to work!',
            style: TextStyle(
                color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
          )),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateCourse()));
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              fixedSize: MaterialStateProperty.all(const Size(240, 25)),
            ),
            child: const Text('Create a course'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ViewCourses()));
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              fixedSize: MaterialStateProperty.all(const Size(240, 25)),
            ),
            child: const Text('Edit Existing Courses'),
          )
        ],
      ),
    );
  }
}
