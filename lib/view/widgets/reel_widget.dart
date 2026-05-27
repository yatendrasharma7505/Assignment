import 'package:assignment/model/response/reels_response.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class ReelWidget extends StatefulWidget {
  final Document document;
  final CachedVideoPlayerPlusController? controller;
  final bool isVisible;

  const ReelWidget({
    super.key,
    required this.document,
    required this.controller,
    required this.isVisible,
  });

  @override
  State<ReelWidget> createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  bool _showPlayIcon = false;

  @override
  void didUpdateWidget(ReelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      widget.controller?.play();
      _showPlayIcon = false;
    } else if (!widget.isVisible && oldWidget.isVisible) {
      widget.controller?.pause();
    }
  }

  void _togglePlay() {
    final c = widget.controller;
    if (c == null || !c.value.isInitialized) return;
    if (c.value.isPlaying) {
      c.pause();
      setState(() => _showPlayIcon = true);
    } else {
      c.play();
      setState(() => _showPlayIcon = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildVideo(),
        _buildGradient(),
        _buildSideActions(),
        _buildBottomInfo(),
        if (_showPlayIcon) _buildPlayOverlay(),
      ],
    );
  }

  Widget _buildVideo() {
    final c = widget.controller;
    if (c == null || !c.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return GestureDetector(
      onTap: _togglePlay,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: c.value.size.width,
          height: c.value.size.height,
          child: CachedVideoPlayerPlus(c),
        ),
      ),
    );
  }

  Widget _buildPlayOverlay() {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 200,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Positioned(
      left: 16,
      right: 72,
      bottom: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.document.fields.username.stringValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.document.fields.caption.stringValue,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSideActions() {
    return Positioned(
      right: 12,
      bottom: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _actionButton(
            Icons.favorite_outline,
            widget.document.fields.likes.integerValue.toString(),
          ),
          const SizedBox(height: 20),
          _actionButton(Icons.chat_outlined, ''),
          const SizedBox(height: 20),
          _actionButton(Icons.share_outlined, ''),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 4),
        if (label.isNotEmpty)
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
      ],
    );
  }
}
