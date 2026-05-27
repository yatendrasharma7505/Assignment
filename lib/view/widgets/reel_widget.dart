import 'package:assignment/model/response/reels_response.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class ReelWidget extends StatefulWidget {

  final Document document;
  final CachedVideoPlayerPlusController? controller;

  const ReelWidget({
    super.key,
    required this.document,
    required this.controller,
  });

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {

  bool showPlay = false;

  @override
  Widget build(BuildContext context) {

    final videoController = widget.controller;

    return Stack(

      fit: StackFit.expand,

      children: [

        if (videoController != null &&
            videoController.value.isInitialized)

          GestureDetector(

            onTap: () {

              if (videoController.value.isPlaying) {

                videoController.pause();

                showPlay = true;

              } else {

                videoController.play();

                showPlay = false;
              }

              setState(() {});
            },

            child: FittedBox(

              fit: BoxFit.cover,

              child: SizedBox(

                width: videoController.value.size.width,
                height: videoController.value.size.height,

                child: CachedVideoPlayerPlus(videoController),
              ),
            ),
          )

        else

          const Center(
            child: CircularProgressIndicator(),
          ),

        Positioned(

          left: 0,
          right: 0,
          bottom: 0,

          child: Container(

            height: 200,

            decoration: const BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Colors.transparent,
                  Colors.black87,
                ],
              ),
            ),
          ),
        ),

        Positioned(

          left: 15,
          bottom: 40,
          right: 80,

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                widget.document.fields.username.stringValue,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              Text(

                widget.document.fields.caption.stringValue,

                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        Positioned(

          right: 12,
          bottom: 100,

          child: Column(

            children: [

              const Icon(
                Icons.favorite_outline,
                color: Colors.white,
                size: 32,
              ),

              const SizedBox(height: 5),

              Text(

                widget.document.fields.likes.integerValue.toString(),

                style: const TextStyle(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.chat_outlined,
                color: Colors.white,
                size: 32,
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.send,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),

        if (showPlay)

          Center(

            child: Container(

              height: 70,
              width: 70,

              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.4),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
      ],
    );
  }
}