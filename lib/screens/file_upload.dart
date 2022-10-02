import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:yoga_app/services/upload_file.dart';
import 'package:yoga_app/services/all_video_player.dart';

class TransferFiles {
  String path;
  String fileName;

  TransferFiles({required this.path, required this.fileName});
}

TransferFiles? pathAndName;
bool isVideoNull = true;
Widget video = Container(
  height: 300,
  width: 300,
  decoration: const BoxDecoration(color: Colors.black),
  child: const Center(
    child: Text(
      'Select a video from your files',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
late Widget uploadButton;
void Function()? upload = () {};

class Upload extends StatefulWidget {
  String? courseName;

  Upload({Key? key, required this.courseName}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Files',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.cyan[100],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: [
            video,
            const SizedBox(
              height: 20,
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
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      'mkv',
                      'mov',
                      'mp4',
                      'webp',
                    ],
                  );

                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No file selected'),
                      ),
                    );
                    return null;
                  }
                  final path = results.files.single.path!;
                  final fileName = results.files.single.name;
                  File file = File(path);
                  pathAndName = TransferFiles(path: path, fileName: fileName);
                  setState(() {
                    video = Container(
                        height: 300,
                        width: 300,
                        padding: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: AllVideoPlayer(
                          videoPlayerController:
                              VideoPlayerController.file(file),
                          looping: true,
                        ));
                    upload = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadFile(
                                  courseName: widget.courseName,
                                )),
                      );
                    };
                  });
                  isVideoNull = false;
                },
                child: const Text('Browse')),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                fixedSize: MaterialStateProperty.all(const Size(240, 25)),
              ),
              onPressed: upload,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
