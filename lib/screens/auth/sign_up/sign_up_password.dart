import 'package:flutter/material.dart';
import 'package:hopin/screens/auth/auth_service.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:hopin/data/providers/user_info_provider.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Define Your Password",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "It must have at least 8 characters, 1 letter, 1 number and 1 special character.",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Input(
                keyboardType: TextInputType.visiblePassword,
                hint: "Password",
                textObscure: true,
                changeSenseFunc: (field, value) {
                  context.read<UserInfoProvider>().updatePassword(value: value);
                },
                validatorFunc: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                    return 'Password must contain at least one letter';
                  }
                  if (!RegExp(r'\d').hasMatch(value)) {
                    return 'Password must contain at least one number';
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return 'Password must contain at least one special character';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,

                child: Fab(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authService.value
                          .signUp(
                            email: context.read<UserInfoProvider>().email,
                            password: context.read<UserInfoProvider>().password,
                          )
                          .then((value) {
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, '/home');
                          })
                          .catchError((error) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          });
                      Navigator.pushNamed(context, '/login');
                      context.read<UserInfoProvider>().printInfo();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
