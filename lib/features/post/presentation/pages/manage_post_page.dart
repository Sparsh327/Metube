import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/common/widgets/image_display_widget.dart';
import 'package:metube/features/post/domain/entities/post.dart';
import 'package:metube/features/post/presentation/bloc/post_bloc.dart';
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
            MyPostList(),
          ],
        ),
      ),
    );
  }
}

class MyPostList extends StatelessWidget {
  const MyPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostDisplaySuccess) {
          return Expanded(
            child: ListView.separated(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostThumbnailWidget(post: state.posts[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
            ),
          );
        }
        if (state is PostFailure) {
          return Center(child: Text(state.error));
        }
        return Container();
      },
    );
  }
}

class PostThumbnailWidget extends StatelessWidget {
  const PostThumbnailWidget({required this.post, super.key});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 200,
      width: size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageUrlWidget(
              borderRadius: 0,
              height: 100,
              imgUrl: post.thumbnailUrl,
              width: size.width),
          const SizedBox(
            height: 10,
          ),
          Text(post.title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
