import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'edit_video.dart';

Widget? title;

late DatabaseReference ref;

class EditCourse extends StatefulWidget {
  String? courseName;

  EditCourse({Key? key, required this.courseName}) : super(key: key);

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {

  final name = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    ref = FirebaseDatabase.instance.ref('courses/${widget.courseName}/videos');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Viewing Course',
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
                      title = Text(value['title'].toString());
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
                              //leading: const Icon(Icons.title_outlined),
                              leading: Icon(Icons.title_outlined),
                              title: title,
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
                                            builder: (context) => EditVideo(
                                              value: value,
                                              snapshotKey: snapshot.key as String,
                                            )));
                                  },
                                  child: const Text('Edit Video'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Share.share(
                                        'Check out the latest course: ${value['title']} uploaded on the Yoga App! Download the app now!');
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
    );
  }
}
