import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/features/post/domain/usecases/upload_post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final UploadPost uploadPost;
  PostBloc(this.uploadPost) : super(PostInitial()) {
    on<PostEvent>((event, emit) => emit(PostLoading()));
    on<AddPost>(_onAddPost);
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
}
