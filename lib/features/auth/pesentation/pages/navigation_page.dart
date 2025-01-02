import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/app_user/app_user_cubit.dart';
import 'package:metube/features/auth/pesentation/pages/login_page.dart';
import 'package:metube/features/main/presentation/pages/main_page.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppUserCubit, AppUserState, bool>(
      selector: (state) {
        return state is AppUserLoggedIn;
      },
      builder: (context, isLoggedIn) {
        if (isLoggedIn) {
          return const BottomNavPage();
        }
        return const LoginPage();
      },
    );
  }
}
