import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/features/post/domain/entities/post.dart';
import 'package:metube/features/post/presentation/widgets/video_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:async';

import '../../../../core/app_user/app_user_cubit.dart';
import '../bloc/post_bloc.dart';

class VideoInList extends StatelessWidget {
  const VideoInList({required this.post, super.key});
  final List<Post> post;
  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    return Expanded(
      child: RefreshIndicator(  
        onRefresh: () async {
          postBloc.add(FetchUserPosts(userId: userId));
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: post.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: post[index].videoUrl,
                      title: post[index].title, // Pass your video title here
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  child: Column(
                    children: [
                      VideoCard(
                        videoUrl: post[index].videoUrl,
                        thumbnailUrl: post[index].thumbnailUrl,
                        key: ValueKey(index),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(post[index].title),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const VideoCard({
    required this.videoUrl,
    required this.thumbnailUrl,
    super.key,
  });

  @override
  VideoCardState createState() => VideoCardState();
}

class VideoCardState extends State<VideoCard>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isVideoVisible = false;
  Timer? _playTimer;
  bool _showThumbnail = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    try {
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video controller: $e');
    }

    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    _isVideoVisible = info.visibleFraction > 0.7;

    _playTimer?.cancel();
    if (_isVideoVisible) {
      // Start a timer to play the video after the user stops scrolling
      _playTimer = Timer(const Duration(milliseconds: 500), () {
        if (_isVideoVisible && mounted) {
          _showThumbnail = false;
          _controller.play();
        }
      });
    } else {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showThumbnail = true;
      }
    }
  }

  @override
  void dispose() {
    _playTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: Key('video-${widget.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_isInitialized) VideoPlayer(_controller),
                if (_showThumbnail)
                  Image.network(
                    widget.thumbnailUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.error));
                    },
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
