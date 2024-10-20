import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metube/core/common/widgets/loader.dart';
import 'package:metube/core/utils/show_snackbar.dart';
import 'package:metube/features/auth/pesentation/widgets/auth_field.dart';

import '../bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                    controller: emailController,
                    hintText: "Email",
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
                    height: 15,
                  ),
                  AuthField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    showPassword: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authBloc.add(
                        AuthSignUp(
                          email: emailController.text,
                          password: passwordController.text,
                          name: emailController.text.split("@")[0],
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
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

// class _EmailTextFieldWidget extends StatelessWidget {
//   const _EmailTextFieldWidget();

//   @override
//   Widget build(BuildContext context) {
//     final RegExp emailRegex = RegExp(
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
//     return TextFormField(
//       onChanged: (val) {
//         //   store.email = val.trim();
//       },
//       cursorColor: Colors.black,
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'Please enter an email';
//         } else if (!emailRegex.hasMatch(value)) {
//           return 'Please enter valid email';
//         }
//         return null;
//       },
//       decoration: const InputDecoration(
//         contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         // focusedBorder: OutlineInputBorder(
//         //   borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
//         //   borderRadius: BorderRadius.circular(10),
//         // ),
//         // enabledBorder: OutlineInputBorder(
//         //   borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
//         //   borderRadius: BorderRadius.circular(10),
//         // ),
//         filled: true,
//         hintStyle: TextStyle(
//           color: Color(0xFF474B51),
//           fontSize: 16,
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//         ),
//         hintText: "Email",
//         //   fillColor: const Color(0xFFF7F8FA)
//       ),
//     );
//   }
// }

// class _PasswordTextFieldWidget extends StatefulWidget {
//   const _PasswordTextFieldWidget();

//   @override
//   State<_PasswordTextFieldWidget> createState() =>
//       _PasswordTextFieldWidgetState();
// }

// class _PasswordTextFieldWidgetState extends State<_PasswordTextFieldWidget> {
//   bool obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     final RegExp passwordRegex =
//         RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$');
//     return TextFormField(
//       onChanged: (val) {},
//       //controller: TextEditingController(text: store.companyName),
//       cursorColor: Colors.black,
//       decoration: InputDecoration(
//           //prefixIcon: Icon(Icons.search),
//           suffixIcon: IconButton(
//               onPressed: () {
//                 setState(() {
//                   obscureText = !obscureText;
//                 });
//               },
//               icon: obscureText
//                   ? const Icon(CupertinoIcons.eye_fill)
//                   : const Icon(CupertinoIcons.eye_slash_fill)),
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Color(0xFFC4C4C4)),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           filled: true,
//           hintStyle: const TextStyle(
//             color: Color(0xFF474B51),
//             fontSize: 16,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//           ),
//           hintText: "Password",
//           fillColor: const Color(0xFFF7F8FA)),
//       obscureText: obscureText,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'Please enter a password';
//         } else if (!passwordRegex.hasMatch(value)) {
//           return 'Uppercase Lowercase Numeric & Special Character';
//         }
//         return null;
//       },
//     );
//   }
// }
