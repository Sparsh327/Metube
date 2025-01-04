import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:metube/core/utils/video_picker.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Add Post",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const AddVideoPost()
            ],
          ),
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
  File? thumbNailImage;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> handleVideoSelection() async {
    setState(() {
      isLoading = true;
    });
    final (videoFile, error) = await VideoPickerService().pickVideo();
    if (error != null) {
      log(error);
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (videoFile != null) {
      final (thumbNail, error) =
          await VideoPickerService().getVideoThumbnail(videoFile);

      if (error == null && thumbNail != null) {
        setState(() {
          thumbNailImage = thumbNail;
          isLoading = false;
        });
        return;
      }
      if (error != null) {
        log(error);
        setState(() {
          isLoading = false;
        });
        return;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            height: size.height * 0.3,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (isLoading) ...[
                const CircularProgressIndicator()
              ] else ...[
                if (thumbNailImage != null)
                  GestureDetector(
                    onTap: handleVideoSelection,
                    child: Image.file(
                      thumbNailImage!,
                      height: size.height * 0.25,
                      width: size.width * 0.8,
                      fit: BoxFit.fill,
                    ),
                  )
                else
                  Center(
                      child: TextButton(
                    onPressed: handleVideoSelection,
                    child: const Text("Select Video"),
                  ))
              ],
            ]),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Title",
            ),
            controller: titleController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              maxLines: 4,
              maxLength: 100,
              controller: descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              }),
          const SizedBox(height: 20),
          FloatingActionButton.extended(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  log("message");
                }
              },
              label: const Row(
                children: [Text("Post Video")],
              ))
        ],
      ),
    );
  }
}
