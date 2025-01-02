import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/common/widgets/loader.dart';
import 'package:metube/core/utils/show_snackbar.dart';
import 'package:metube/features/auth/pesentation/bloc/auth_bloc.dart';
import 'package:metube/features/auth/pesentation/pages/signup_page.dart';
import 'package:metube/features/auth/pesentation/widgets/auth_field.dart';
import 'package:metube/features/main/presentation/pages/main_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context: context, message: state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavPage()),
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 10, top: 30),
                      child: Text(
                        "Login to your Account",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                    showPassword: false,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    showPassword: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authBloc.add(
                          AuthLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Login",
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, SignupPage.route());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
