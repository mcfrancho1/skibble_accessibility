import 'dart:async';
import 'dart:io';

// import 'package:better_player/better_player.dart';
import 'package:skibble/utils/flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/utils/constants.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


import '../utils/feed_player/flick_multi_manager.dart';
import '../utils/feed_player/flick_multi_player.dart';


class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    Key? key,
    required this.urlType,
    required this.videoUrl,
    required this.isFullScreen,
    this.size,
    this.isLooping = false,
    this.isOnStoryScreen = false,
    this.isOnExplorePage = false,
    this.generatedGradient
  }) : super(key: key);

  // final VideoPlayerController videoPlayerController;
  final String urlType;
  final String videoUrl;
  final bool isFullScreen;
  final Size? size;
  final bool isLooping;
  final bool isOnStoryScreen;
  final bool isOnExplorePage;


  final void Function(Color color1, Color color2)? generatedGradient;

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  // late VideoPlayerController _videoPlayerController;
  // late BetterPlayerController _betterPlayerController;
  late FlickManager flickManager;
  late FlickMultiManager flickMultiManager;

  GlobalKey videoKey = GlobalKey();
  GlobalKey? currentKey;
  GlobalKey paintKey = GlobalKey();

  final StreamController<Color> stateController = StreamController<Color>();
  Color color1 = const Color(0xFFFFFFFF);
  Color color2 = const Color(0xFFFFFFFF);


  @override
  void initState() {
    // TODO: implement initState
    // initializePlayer();
    flickMultiManager = FlickMultiManager();

    flickManager = FlickManager(
        videoPlayerController: widget.urlType == 'file' ?
        VideoPlayerController.file(
          File(widget.videoUrl),
        )
            :
        VideoPlayerController.network(widget.videoUrl,)
    );

    flickMultiManager.init(flickManager, true);
    super.initState();
  }


  @override
  void dispose() {

    // _videoPlayerController.dispose();
    flickMultiManager.remove(flickManager);
    // flickManager.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return widget.isFullScreen ? Scaffold(
      // appBar: AppBar(),
      backgroundColor: Colors.black54,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
            ),
            Positioned(
              top: 60,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: kLightSecondaryColor),
                  child: Icon(Iconsax.arrow_left, color: kDarkSecondaryColor,))))
          ],
        ),
      ),
    )
            :
    ClipRRect(
      borderRadius: widget.isOnExplorePage ? BorderRadius.zero: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          //TODO: Add a good image here
          FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(controls: null,),
          ),
          // FlickVideoPlayer(
          //   flickManager: flickManager!,
          // // flickVideoWithControls: FlickLeftDuration(),
          // // BetterPlayerDataSource(
          // // BetterPlayerDataSourceType.network, widget.videoUrl),
          // // key: Key(widget.videoUrl.hashCode.toString()),
          // // playFraction: 0.8,
          // //   _videoPlayerController
          //   // controller: _chewieController,
          //   // widget.videoUrl,
          //   // betterPlayerConfiguration: BetterPlayerConfiguration(
          //   //   autoPlay: true,
          //   //   looping: true,
          //   //   aspectRatio: ,
          //   //   controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false)
          //   // ),
          //   // controller: _betterPlayerController,
          // ),
        ],
      ),
    );
  }
}

class CustomVideoMultiPlayerList extends StatefulWidget {
  const CustomVideoMultiPlayerList({Key? key, this.videoUrl, this.image,
    this.isOnExplorePage = false,
    this.isNetworkImage = true
  }) : super(key: key);

  final String? videoUrl;
  final String? image;
  final bool isNetworkImage;
  final bool isOnExplorePage;


  @override
  _CustomVideoMultiPlayerListState createState() => _CustomVideoMultiPlayerListState();
}

class _CustomVideoMultiPlayerListState extends State<CustomVideoMultiPlayerList> {

  @override
  void initState() {
    // TODO: implement initState
    flickMultiManager = FlickMultiManager();

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  late FlickMultiManager flickMultiManager;

  @override
  Widget build(BuildContext context) {

    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 1 && this.mounted) {
          flickMultiManager.play();

        }
        else {
          flickMultiManager.pause();
        }
      },
      child: ClipRRect(
        borderRadius: widget.isOnExplorePage ? BorderRadius.zero: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //TODO: Add a good image here

            widget.image != null && widget.videoUrl != null ?
            FlickMultiPlayer(
              url: widget.videoUrl!,
              image: widget.image,
              flickMultiManager: flickMultiManager,
              isNetworkImage: widget.isNetworkImage,
              isOnExplorePage: widget.isOnExplorePage,
              // image: 'https://images.unsplash.com/photo-1521732670659-b8c918da61dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fGZvb2QlMjBzaG93c3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=800&q=60',
            ) : Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200
              ),

              child: const Center(
                child: Icon(Icons.error_outline_rounded),
              ),
            ),
            // FlickVideoPlayer(
            //   flickManager: flickManager!,
            // // flickVideoWithControls: FlickLeftDuration(),
            // // BetterPlayerDataSource(
            // // BetterPlayerDataSourceType.network, widget.videoUrl),
            // // key: Key(widget.videoUrl.hashCode.toString()),
            // // playFraction: 0.8,
            // //   _videoPlayerController
            //   // controller: _chewieController,
            //   // widget.videoUrl,
            //   // betterPlayerConfiguration: BetterPlayerConfiguration(
            //   //   autoPlay: true,
            //   //   looping: true,
            //   //   aspectRatio: ,
            //   //   controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false)
            //   // ),
            //   // controller: _betterPlayerController,
            // ),
          ],
        ),
      ),
    );
  }
}





