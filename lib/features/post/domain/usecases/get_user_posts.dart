import 'package:fpdart/fpdart.dart';
import 'package:metube/features/post/domain/entities/post.dart';

import '../../../../core/error/faliures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/post_repository.dart';

class GetUserPosts implements UseCase<List<Post>, String> {
  final PostRepository postRepository;

  GetUserPosts({required this.postRepository});
  @override
  Future<Either<Failure, List<Post>>> call(String userId) async {
    return await postRepository.getPostsByUserId(userId);
  }
}
