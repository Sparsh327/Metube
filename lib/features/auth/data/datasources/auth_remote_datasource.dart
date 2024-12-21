import 'dart:developer';

import 'package:metube/core/error/exceptions.dart';
import 'package:metube/features/auth/data/models/app_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<AppUserModel> signUpWithEmailAndPassword(
      {required String email, required String password, required String name});
  Future<AppUserModel> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<AppUserModel?> getCurrentUserData();

  Future<void> userLogout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

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
      return AppUserModel.fromMap(response.user!.toJson()).copyWith(
        email: response.user!.email,
      );
    } catch (e) {
      log(e.toString());
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

      return AppUserModel.fromMap(response.user!.toJson()).copyWith(
        email: response.user!.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppUserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return AppUserModel.fromMap(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> userLogout() async {
    await supabaseClient.auth.signOut();
  }
}
