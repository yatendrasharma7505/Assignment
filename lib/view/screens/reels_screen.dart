import 'package:assignment/cubit/reels_cubit.dart';
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
  final PageController _pageController = PageController();
  final Map<int, CachedVideoPlayerPlusController> _controllers = {};
  int _currentPage = 0;
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    context.read<ReelsCubit>().fetchReels();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    final prev = _currentPage;
    _currentPage = index;
    _manageControllers();
    _handlePlayPause(prev, index);
  }

  void _handlePlayPause(int prev, int current) {
    _controllers[prev]?.pause();
    _controllers[current]?.play();
  }

  void _manageControllers() {
    final needed = <int>{};
    for (int i = 0; i < 4; i++) {
      final idx = _currentPage + i;
      if (idx < _totalItems) needed.add(idx);
    }

    _controllers.removeWhere((key, c) {
      if (!needed.contains(key)) {
        c.dispose();
        return true;
      }
      return false;
    });

    for (final idx in needed) {
      if (!_controllers.containsKey(idx)) {
        _initController(idx);
      }
    }
  }

  void _initController(int index) {
    final docs = (context.read<ReelsCubit>().state as ReelsLoaded)
        .reels
        .documents;
    if (index >= docs.length) return;
    final url = docs[index].fields.url.stringValue.trim();
    final controller = CachedVideoPlayerPlusController.networkUrl(Uri.parse(url));
    _controllers[index] = controller;
    controller.initialize().then((_) {
      if (mounted) {
        if (index == _currentPage) controller.play();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          if (state is ReelsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReelsError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.white)),
            );
          }
          if (state is ReelsLoaded) {
            final docs = state.reels.documents;
            _totalItems = docs.length;
            if (_controllers.isEmpty && docs.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _manageControllers());
            }
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: docs.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => ReelWidget(
                document: docs[index],
                controller: _controllers[index],
                isVisible: index == _currentPage,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
