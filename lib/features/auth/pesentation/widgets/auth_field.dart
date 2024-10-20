import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  const AuthField(
      {required this.showPassword,
      required this.controller,
      required this.hintText,
      super.key});
  final String hintText;
  final bool showPassword;
  final TextEditingController controller;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (val) {},
      //controller: TextEditingController(text: store.companyName),
      obscureText: widget.showPassword ? obscureText : false,
      decoration: InputDecoration(
        suffixIcon: widget.showPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: obscureText
                    ? const Icon(CupertinoIcons.eye)
                    : const Icon(CupertinoIcons.eye_slash_fill))
            : null,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        hintText: widget.hintText,
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a ${widget.hintText}';
        }
        return null;
      },
    );
  }
}
