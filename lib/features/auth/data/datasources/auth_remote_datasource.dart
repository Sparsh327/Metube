import 'package:metube/core/error/exceptions.dart';
import 'package:metube/features/auth/data/models/app_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<AppUserModel> signUpWithEmailAndPassword(
      {required String email, required String password, required String name});
  Future<AppUserModel> loginWithEmailAndPassword(
      {required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<AppUserModel> signUpWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {"name": name});
      if (response.user == null) {
        throw const ServerException("User is null");
      }
      return AppUserModel.fromMap(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppUserModel> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw const ServerException("User is null");
      }

      return AppUserModel.fromMap(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
