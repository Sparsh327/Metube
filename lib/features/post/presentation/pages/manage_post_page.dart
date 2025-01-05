import 'package:flutter/material.dart';
import 'package:metube/features/post/presentation/pages/add_post.dart';

class ManagePostPage extends StatelessWidget {
  const ManagePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Post"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddPostPage()));
            },
            icon: const Icon(Icons.video_call),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Text("Manage Post"),
            ),
          ],
        ),
      ),
    );
  }
}
