// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoController videoController;
  late Player player;
  late bool isPlayerInitialized;
  StreamSubscription<bool>? playCompletedSubscription;
  late int playCount;

  @override
  void initState() {
    super.initState();
    isPlayerInitialized = false;
    playCount = 0;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    player = Player();
    videoController = await VideoController.create(player.handle,
        enableHardwareAcceleration: false, width: 480, height: 854);
    playCompletedSubscription = player.streams.isCompleted.listen((event) {
      playCount++;
      print('################################ Completed[$event]. PlayCount: $playCount');
    });
    await player.open(Playlist(
        [
          Media('asset://assets/falling_man_shorts.mp4'),
          Media('asset://assets/falling_man_shorts.mp4'),
          Media('asset://assets/falling_man_shorts.mp4'),
          Media('asset://assets/falling_man_shorts.mp4'),
        ]
    ), play: true, evictCache: true);
    setState(() {
      isPlayerInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isPlayerInitialized) return const Center(child: Icon(Icons.hourglass_top),);
    return Center(child: Video(controller: videoController,));
  }

  @override
  void dispose() {
    videoController.dispose();
    player.dispose();
    playCompletedSubscription?.cancel();
    super.dispose();
  }
}
