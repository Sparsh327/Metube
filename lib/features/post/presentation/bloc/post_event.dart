part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

final class AddPost extends PostEvent {
  final File videoFile;
  final File thumbNailFile;
  final String title;
  final String description;

  final String userId;

  AddPost({
    required this.videoFile,
    required this.thumbNailFile,
    required this.title,
    required this.description,
    required this.userId,
  });
}

final class FetchUserPosts extends PostEvent {
  final String userId;

  FetchUserPosts({required this.userId});
}
