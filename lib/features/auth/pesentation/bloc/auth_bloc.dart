import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/app_user/app_user_cubit.dart';
import 'package:metube/core/common/entities/user.dart';
import 'package:metube/core/usecase/usecase.dart';
import 'package:metube/features/auth/domain/usecases/current_user.dart';
import 'package:metube/features/auth/domain/usecases/user_login.dart';
import 'package:metube/features/auth/domain/usecases/user_logout.dart';
import 'package:metube/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final UserLogout _userLogout;

  AuthBloc(
      {required UserLogin userLogin,
      required UserSignUp userSignUp,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit,
      required UserLogout userLogout})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _userLogout = userLogout,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
  }
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold((l) => emit(AuthFailure(l.message)), (r) {
      log(r.email.toString());
      _emitAuthSuccess(r, emit);
    });
  }

  Future<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    return res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) async {
        final currentUserRes = await _currentUser(NoParams());

        if (!emit.isDone) {
          currentUserRes.fold(
            (l) => emit(AuthFailure(l.message)),
            (user) {
              if (!emit.isDone) {
                _appUserCubit.updateUser(user);
                emit(AuthSuccess(user));
              }
            },
          );
        }
      },
    );
  }

  Future<void> _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final loginRes = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    return loginRes.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) async {
        // After successful login, fetch current user
        final currentUserRes = await _currentUser(NoParams());

        if (!emit.isDone) {
          currentUserRes.fold(
            (l) => emit(AuthFailure(l.message)),
            (user) {
              if (!emit.isDone) {
                _appUserCubit.updateUser(user);
                emit(AuthSuccess(user));
              }
            },
          );
        }
      },
    );
  }

  void _onAuthLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogout(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => _emitAuthLogout(emit),
    );
  }

  void _emitAuthSuccess(
    AppUser user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _emitAuthLogout(Emitter<AuthState> emit) {
    _appUserCubit.updateUser(null);
    emit(AuthInitial());
  }
}
