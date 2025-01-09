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

  Future<List<PostModel>> getPostsByUserId(String userId);
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
      // Get current user ID
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) throw const ServerException('User not authenticated');

      // Create paths with user ID
      final videoPath =
          '$userId/$postId-video${_getFileExtension(videoFile.path)}';
      final thumbnailPath =
          '$userId/$postId-thumbnail${_getFileExtension(thumbNailFile.path)}';

      // Upload files
      await supabaseClient.storage.from('videos').upload(videoPath, videoFile);

      await supabaseClient.storage
          .from('thumbnails')
          .upload(thumbnailPath, thumbNailFile);

      // Get public URLs
      final videoUrl =
          supabaseClient.storage.from('videos').getPublicUrl(videoPath);

      final thumbnailUrl =
          supabaseClient.storage.from('thumbnails').getPublicUrl(thumbnailPath);

      return {
        'videoUrl': videoUrl,
        'thumbnailUrl': thumbnailUrl,
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    try {
      final data = await supabaseClient
          .from('posts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return data.map((post) => PostModel.fromJson(post)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Helper function to get file extension
  String _getFileExtension(String filePath) {
    return filePath.substring(filePath.lastIndexOf('.'));
  }
}
