import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:metube/core/error/faliures.dart';
import 'package:metube/features/post/domain/entities/post.dart';

abstract interface class PostRepository {
  Future<Either<Failure, Post>> uploadPost({
    required File videoFile,
    required File thumbNailFile,
    required String title,
    required String description,
    required String username,
    required String userId,
  });
}
