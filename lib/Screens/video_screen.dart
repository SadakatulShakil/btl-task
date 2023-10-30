import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late bool isPaused;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.asset(
      'assets/videos/infinite_loop_zoom.mp4',
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 9 / 16,
      autoPlay: false,
      looping: false,
    );

    _initializeAndPlay();
  }

  Future<void> _initializeAndPlay() async {
    await _videoPlayerController.initialize();
    isPaused = false;

    // Calculate pause and resume intervals based on video duration
    int videoDurationInSeconds = _videoPlayerController.value.duration.inSeconds;
    int pauseResumeInterval = videoDurationInSeconds ~/ 5;

    _startPauseResumeLoop(pauseResumeInterval);
  }

  void _startPauseResumeLoop(int interval) {
    Future.delayed(Duration(seconds: interval), () {
      if (!isPaused) {
        _videoPlayerController.pause();
        isPaused = true;
      } else {
        _videoPlayerController.play();
        isPaused = false;
      }
      _startPauseResumeLoop(interval); // Schedule the next iteration
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _videoPlayerController.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _videoPlayerController.play();
              return Chewie(
                controller: _chewieController,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
