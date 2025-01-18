import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:metube/core/app_user/app_user_cubit.dart';
import 'package:metube/core/network/connection_checker.dart';
import 'package:metube/core/secrets/app_secrets.dart';
import 'package:metube/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:metube/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';
import 'package:metube/features/auth/domain/usecases/current_user.dart';
import 'package:metube/features/auth/domain/usecases/user_login.dart';
import 'package:metube/features/auth/domain/usecases/user_logout.dart';
import 'package:metube/features/auth/domain/usecases/user_sign_up.dart';
import 'package:metube/features/auth/pesentation/bloc/auth_bloc.dart';
import 'package:metube/features/post/data/datasources/post_remote_data_source.dart';
import 'package:metube/features/post/domain/repository/post_repository.dart';
import 'package:metube/features/post/presentation/bloc/post_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'post/data/repositories/post_repository_impl.dart';
import 'post/domain/usecases/get_user_posts.dart';
import 'post/domain/usecases/upload_post.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env");
  _initAuth();
  _initPost();
  final supabaseClient = await Supabase.initialize(
      url: AppSecrets().supabaseUrl, anonKey: AppSecrets().anonKey);

  serviceLocator.registerLazySingleton(() => supabaseClient.client);

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
          connectionChecker: serviceLocator(),
          authRemoteDataSource: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      appUserCubit: serviceLocator(),
      currentUser: serviceLocator(),
      userLogout: serviceLocator(),
    ),
  );
}

void _initPost() {
  serviceLocator
    ..registerFactory<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<PostRepository>(
      () => PostRepositoryImpl(
        postRemoteDataSource: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadPost(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserPosts(
        postRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PostBloc(
        serviceLocator(),
        serviceLocator(),
      ),
    );
}
