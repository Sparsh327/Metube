import 'dart:io';

import 'package:metube/core/error/exceptions.dart';
import 'package:metube/features/post/data/model/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PostRemoteDataSource {
  Future<PostModel> uploadPost(PostModel post);
  Future<Map<String, String>> uploadMedia(
      {required String postId,
      required File videoFile,
      required File thumbNailFile});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  PostRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<PostModel> uploadPost(PostModel post) async {
    try {
      final data =
          await supabaseClient.from('posts').insert(post.toJson()).select();

      return PostModel.fromJson(data.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, String>> uploadMedia({
    required String postId,
    required File videoFile,
    required File thumbNailFile,
  }) async {
    try {
      await supabaseClient.storage
          .from('videos')
          .upload(postId, videoFile);
      await supabaseClient.storage
          .from('thumbnails')
          .upload(postId, thumbNailFile);

      final videoUrl = supabaseClient.storage.from('videos').getPublicUrl(
            postId,
          );
      final thumbnailUrl =
          supabaseClient.storage.from('thumbnails').getPublicUrl(
                postId,
              );
      return {
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
