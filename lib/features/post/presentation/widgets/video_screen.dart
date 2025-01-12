import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;
  bool _isControlsVisible = true;
  bool _isDraggingProgress = false;
  Timer? _controlsTimer;

  // PiP controller
  OverlayEntry? _pipOverlay;
  bool _isInPiP = false;
  Offset _pipPosition = const Offset(16, 100);
  final Size _pipSize = const Size(160, 90);

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    setState(() {});
    _controller.play();
    _startControlsTimer();
  }

  void _startControlsTimer() {
    if (!_isDraggingProgress) {
      _controlsTimer?.cancel();
      _controlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDraggingProgress) {
          setState(() => _isControlsVisible = false);
        }
      });
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  void _showPiP() {
    if (_pipOverlay != null) return;

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: _pipPosition.dx,
        top: _pipPosition.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _pipPosition += details.delta;
              _pipOverlay?.markNeedsBuild();
            });
          },
          child: Container(
            width: _pipSize.width,
            height: _pipSize.height,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: VideoPlayer(_controller),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: _closePiP,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
    _pipOverlay = overlay;
    _isInPiP = true;
  }

  void _closePiP() {
    _pipOverlay?.remove();
    _pipOverlay = null;
    _isInPiP = false;
    _controller.pause();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controlsTimer?.cancel();
    _controller.dispose();
    _pipOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _toggleFullScreen();
          return false;
        }
        if (!_isInPiP) {
          _showPiP();
          Navigator.of(context).pop();
        }
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            setState(() => _isControlsVisible = !_isControlsVisible);
            if (_isControlsVisible) _startControlsTimer();
          },
          child: ColoredBox(
            color: Colors.black,
            child: SafeArea(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    if (_isControlsVisible) _buildControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black54,
            Colors.transparent,
            Colors.transparent,
            Colors.black54,
          ],
          stops: [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTopBar(),
          _buildCenterControls(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 48,
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
            _startControlsTimer();
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProgressBar(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeDisplay(),
              Row(
                children: [
                  _buildPlaybackSpeedButton(),
                  IconButton(
                    icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFullScreen,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        trackHeight: 4,
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: Colors.red,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.red,
      ),
      child: Slider(
        value: _controller.value.position.inMilliseconds.toDouble(),
        min: 0.0,
        max: _controller.value.duration.inMilliseconds.toDouble(),
        onChangeStart: (value) {
          setState(() => _isDraggingProgress = true);
          _controlsTimer?.cancel();
        },
        onChangeEnd: (value) {
          setState(() => _isDraggingProgress = false);
          _startControlsTimer();
        },
        onChanged: (value) {
          setState(() {
            _controller.seekTo(Duration(milliseconds: value.toInt()));
          });
        },
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    return Text(
      '${_formatDuration(position)} / ${_formatDuration(duration)}',
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildPlaybackSpeedButton() {
    return PopupMenuButton<double>(
      onSelected: (speed) {
        setState(() => _controller.setPlaybackSpeed(speed));
        _startControlsTimer();
      },
      itemBuilder: (context) => [
        for (final speed in [0.5, 1.0, 1.5, 2.0])
          PopupMenuItem(
            value: speed,
            child: Text('${speed}x'),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '${_controller.value.playbackSpeed}x',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
