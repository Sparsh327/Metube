import '../../domain/entities/post.dart';

class PostModel extends Post {
  PostModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.videoUrl,
      required super.thumbnailUrl,
      required super.userId,
      required super.createdAt,
      required super.updatedAt});

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      id: map['post_id'],
      title: map['title'],
      description: map['description'],
      videoUrl: map['video_url'],
      thumbnailUrl: map['thumbnail_url'],
      userId: map['user_id'],
      createdAt: map['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? userId,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
