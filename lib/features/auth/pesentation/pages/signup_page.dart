import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/common/widgets/loader.dart';
import 'package:metube/core/utils/show_snackbar.dart';
import 'package:metube/features/auth/pesentation/pages/login_page.dart';
import 'package:metube/features/auth/pesentation/widgets/auth_field.dart';
import 'package:metube/features/main/presentation/pages/main_page.dart';

import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context: context, message: state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 10, top: 30),
                      child: Text(
                        "Create your Account",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthField(
                    controller: nameController,
                    hintText: "Name",
                    showPassword: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    controller: emailController,
                    hintText: "Eamil",
                    showPassword: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    controller: passwordController,
                    hintText: "Password",
                    showPassword: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authBloc.add(
                          AuthSignUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: nameController.text.trim(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Sign Up",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
