import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class AllVideoPlayer extends StatefulWidget {
  late VideoPlayerController videoPlayerController;
  late bool looping;
  AllVideoPlayer({Key? key, required this.videoPlayerController, required this.looping}) : super(key: key);

  @override
  State<AllVideoPlayer> createState() => _AllVideoPlayerState();
}

class _AllVideoPlayerState extends State<AllVideoPlayer> {

  late ChewieController _chewieController;
  String videoUrl = 'video url here';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chewieController = ChewieController(videoPlayerController: widget.videoPlayerController,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(controller: _chewieController),
    );
  }
}
