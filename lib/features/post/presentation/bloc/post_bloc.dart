import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/features/post/domain/usecases/get_user_posts.dart';
import 'package:metube/features/post/domain/usecases/upload_post.dart';

import '../../domain/entities/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final UploadPost uploadPost;
  final GetUserPosts getUserPosts;
  PostBloc(this.uploadPost, this.getUserPosts) : super(PostInitial()) {
    on<PostEvent>((event, emit) => emit(PostLoading()));
    on<AddPost>(_onAddPost);
    on<FetchUserPosts>(_onFetchUserPosts);
  }

  void _onAddPost(AddPost event, Emitter<PostState> emit) async {
    final result = await uploadPost(
      UploadPostParams(
        videoFile: event.videoFile,
        thumbnailFile: event.thumbNailFile,
        title: event.title,
        description: event.description,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => emit(PostFailure(failure.message)),
      (post) => emit(PostSuccess()),
    );
  }

  Future<void> _onFetchUserPosts(
      FetchUserPosts event, Emitter<PostState> emit) async {
    final result = await getUserPosts(event.userId);
    result.fold((failure) => emit(PostFailure(failure.message)),
        (posts) => emit(PostDisplaySuccess(posts)));
  }

  // void _updatePostList(Emitter<PostState> emit, Post post) {
  //   final currentState = state;
  //   if (currentState is PostDisplaySuccess) {
  //     final currentPosts = currentState.posts;
  //     emit(PostDisplaySuccess([...currentPosts, post]));
  //   }
  // }
}
