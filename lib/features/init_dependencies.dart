import 'package:get_it/get_it.dart';
import 'package:metube/core/secrets/app_secrets.dart';
import 'package:metube/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:metube/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:metube/features/auth/domain/repository/auth_repository.dart';
import 'package:metube/features/auth/domain/usecases/user_sign_up.dart';
import 'package:metube/features/auth/pesentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabaseClient = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.anonKey);

  serviceLocator.registerLazySingleton(() => supabaseClient.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
