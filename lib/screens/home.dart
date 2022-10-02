import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/screens/profile.dart';
import 'package:yoga_app/screens/upload_type.dart';
import 'package:yoga_app/services/view_course.dart';
import 'package:share_plus/share_plus.dart';
import '../services/auth_gate.dart';
import '../services/realtime_database.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref('courses');

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Database databaseInstance = Database();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.cyan[100],
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Profile()));
              },
              child: const Icon(
                Icons.account_circle_outlined,
              ),
            ),
          ],
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
                              leading: const Icon(Icons.title_outlined),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewCourse(
                                                courseName: snapshot.key)));
                                  },
                                  child: const Text('View Course'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Share.share(
                                        'Check out the latest course: ${value['title'].toString()} uploaded on the Yoga App! Download the app now!');
                                  },
                                  child: const Text('Share'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadType()),
            );
          },
          child: const Icon(Icons.upload_file_outlined),
        ),
      );
    } else {
      return const AuthGate();
    }
  }
}
