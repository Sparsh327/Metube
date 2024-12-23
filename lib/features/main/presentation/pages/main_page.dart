import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/app/splash.dart';
import 'package:metube/core/app_user/app_user_cubit.dart';
import 'package:metube/features/auth/pesentation/bloc/auth_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AppUserCubit, AppUserState>(builder: (context, state) {
              if (state is AppUserLoggedIn) {
                return Text(
                  state.user.name,
                  style: const TextStyle(color: Colors.yellow),
                );
              } else {
                return const Text(
                  "data",
                  style: TextStyle(color: Colors.red),
                );
              }
            }),
            Text(
              "Logged In",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthLoading) {
                return const CupertinoActivityIndicator(
                  color: Colors.white,
                );
              }
              return ElevatedButton(
                  onPressed: () async {
                    authBloc.add(AuthLogout());
                  },
                  child: const Text("Logout"));
            }, listener: (context, state) {
              log(state.toString());
              if (state is AuthInitial) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Splash()),
                  (route) => false,
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
