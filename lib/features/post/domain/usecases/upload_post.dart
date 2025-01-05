import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:metube/features/post/domain/entities/post.dart';
import 'package:metube/features/post/domain/repository/post_repository.dart';

import '../../../../core/error/faliures.dart';
import '../../../../core/usecase/usecase.dart';

class UploadPost implements UseCase<Post, UploadPostParams> {
  final PostRepository postRepository;
  UploadPost({required this.postRepository});
  @override
  Future<Either<Failure, Post>> call(UploadPostParams params) async {
    return await postRepository.uploadPost(
      videoFile: params.videoFile,
      thumbNailFile: params.thumbnailFile,
      title: params.title,
      description: params.description,
      userId: params.userId,
    );
  }
}

class UploadPostParams {
  final String title;
  final String description;

  final String userId;
  final File videoFile;
  final File thumbnailFile;
  UploadPostParams(
      {required this.title,
      required this.description,
      required this.userId,
      required this.videoFile,
      required this.thumbnailFile});
}
