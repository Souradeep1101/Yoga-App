import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app/services/all_video_player.dart';

import 'edit_video_data.dart';

late DatabaseReference ref;
dynamic data;

class EditVideo extends StatefulWidget {
  dynamic value;
  String? snapshotKey;

  EditVideo({Key? key, required this.value, required this.snapshotKey}) : super(key: key);

  @override
  State<EditVideo> createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  @override
  void initState() {
    // TODO: implement initState
    data = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Editing video',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 270,
              child: AllVideoPlayer(
                videoPlayerController:
                VideoPlayerController.network(data['url'].toString()),
                looping: true,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditVideoData(videoName: widget.snapshotKey as String)));
              }, icon: Icon(Icons.edit)),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: [
                Text(
                  data['title'].toString(),
                  style: const TextStyle(
                      fontSize: 24,
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Uploaded on ${data['uploadDate'].toString()} at ${data['uploadTime'].toString()}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            data['description'].toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.clip,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        left: 50,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          color: Colors.white,
                          child: const Text(
                            'Description',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
