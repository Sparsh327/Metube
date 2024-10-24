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
import 'package:metube/features/auth/domain/usecases/user_sign_up.dart';
import 'package:metube/features/auth/pesentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabaseClient = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.anonKey);

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
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ), 
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
        connectionChecker: serviceLocator(),
        authRemoteDataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      appUserCubit: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}
