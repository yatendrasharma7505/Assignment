import 'package:assignment/cubit/reels_cubit.dart';
import 'package:assignment/model/response/reels_response.dart';
import 'package:assignment/view/widgets/reel_widget.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {

  final PageController pageController = PageController();

  Map<int, CachedVideoPlayerPlusController> controllers = {};

  int currentPage = 0;

  List<Document> reels = [];

  @override
  void initState() {
    super.initState();
    context.read<ReelsCubit>().fetchReels();
  }

  void loadVideo(int index) async {

    if (controllers[index] != null) return;

    final controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(reels[index].fields.url.stringValue),
    );

    controllers[index] = controller;

    await controller.initialize();

    controller.setLooping(true);

    if (index == currentPage) {
      controller.play();
    }

    setState(() {});
  }

  @override
  void dispose() {

    for (var item in controllers.values) {
      item.dispose();
    }

    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: BlocConsumer<ReelsCubit, ReelsState>(

        listener: (context, state) {

          if (state is ReelsLoaded) {

            reels = state.reels.documents;

            loadVideo(0);
          }
        },

        builder: (context, state) {

          if (state is ReelsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReelsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state is ReelsLoaded) {

            return PageView.builder(

              controller: pageController,
              scrollDirection: Axis.vertical,
              itemCount: reels.length,

              onPageChanged: (value) {

                controllers[currentPage]?.pause();

                currentPage = value;

                loadVideo(value);

                controllers[value]?.play();

                setState(() {});
              },

              itemBuilder: (context, index) {

                return ReelWidget(
                  document: reels[index],
                  controller: controllers[index],
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}