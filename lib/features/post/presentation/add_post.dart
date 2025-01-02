import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:metube/core/utils/video_picker.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [AddVideoPost()],
        ),
      ),
    ));
  }
}

class AddVideoPost extends StatefulWidget {
  const AddVideoPost({super.key});

  @override
  State<AddVideoPost> createState() => _AddVideoPostState();
}

class _AddVideoPostState extends State<AddVideoPost> {
  @override
  Widget build(BuildContext context) {
    Future<void> handleVideoSelection() async {
      final (videoFile, error) = await VideoPickerService().pickVideo();

      if (error != null) {
        // Handle error through bloc events
        return;
      }

      if (videoFile != null) {
        // Process video
        final String path = videoFile.path;
        log(path);
      }
    }

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: TextButton(
              onPressed: () {
                handleVideoSelection();
              },
              child: const Text("Select Video From Gallery"))),
    );
  }
}
