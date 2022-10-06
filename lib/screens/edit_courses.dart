import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/screens/file_upload.dart';
import 'package:yoga_app/screens/upload_type.dart';
import '../services/edit_course.dart';
import '../services/edit_course_data.dart';
import '../services/view_course.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref('courses');

class ViewCourses extends StatefulWidget {
  const ViewCourses({Key? key}) : super(key: key);

  @override
  State<ViewCourses> createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editing Courses',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Flexible(
              fit: FlexFit.tight,
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    dynamic value = snapshot.value;
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: value['thumbnail'].toString(),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                            ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditCourseData(courseName: snapshot.key as String)));
                                  }, icon: Icon(Icons.edit)),
                              title: Text(value['title'].toString()),
                              subtitle: Text(
                                snapshot.key as String,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Uploaded on ${value['uploadDate'].toString()} at ${value['uploadTime'].toString()}',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  //textColor: const Color(0xFF6200EE),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditCourse(
                                                courseName: snapshot.key)));
                                  },
                                  child: const Text('Edit Course'),
                                ),
                                TextButton(
                                  //textColor: const Color(0xFF6200EE),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Upload(
                                                courseName: snapshot.key)));
                                  },
                                  child: const Text('Upload Video'),
                                ),
                              ],
                            ),
                            //Image.asset('assets/card-sample-image-2.jpg'),
                          ],
                        ),
                      );
                  })),
        ],
      ),
    );
  }
}
