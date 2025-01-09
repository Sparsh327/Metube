import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/exceptions.dart';

import 'package:metube/core/error/faliures.dart';
import 'package:metube/features/post/data/datasources/post_remote_data_source.dart';
import 'package:metube/features/post/data/model/post_model.dart';
import 'package:metube/features/post/domain/entities/post.dart';
import 'package:metube/features/post/domain/repository/post_repository.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;

  PostRepositoryImpl({required this.postRemoteDataSource});

  @override
  Future<Either<Failure, Post>> uploadPost(
      {required File videoFile,
      required File thumbNailFile,
      required String title,
      required String description,
      required String userId}) async {
    try {
      PostModel post = PostModel(
          title: title,
          description: description,
          userId: userId,
          id: const Uuid().v4(),
          videoUrl: "",
          thumbnailUrl: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

      final mediaData = await postRemoteDataSource.uploadMedia(
          postId: post.id, videoFile: videoFile, thumbNailFile: thumbNailFile);
      final vedioUrl = mediaData['videoUrl'];
      final thumbnailUrl = mediaData['thumbnailUrl'];
      post = post.copyWith(
        videoUrl: vedioUrl,
        thumbnailUrl: thumbnailUrl,
      );

      final data = await postRemoteDataSource.uploadPost(post);
      return right(data);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByUserId(String userId) async {
    try {
      final data = await postRemoteDataSource.getPostsByUserId(userId);
      return right(data);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
