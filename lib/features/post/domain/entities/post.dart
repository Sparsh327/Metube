class Post {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String userId;

  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}
