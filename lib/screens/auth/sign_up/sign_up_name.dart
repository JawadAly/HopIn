import 'package:flutter/material.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/data/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
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
                  "What's your name?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Input(
                keyboardType: TextInputType.name,
                hint: "First Name",
                textObscure: false,
                changeSenseFunc: (field, value) {
                  context.read<UserInfoProvider>().updateFirstName(
                    value: value,
                  );
                },
                validatorFunc: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your First Name';
                  }
                  if (RegExp(r'\d').hasMatch(value)) {
                    return 'First Name should not contain numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Input(
                keyboardType: TextInputType.name,
                hint: "Last Name",
                textObscure: false,
                changeSenseFunc: (field, value) {
                  context.read<UserInfoProvider>().updateLastName(value: value);
                },
                validatorFunc: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Last Name';
                  }
                  if (RegExp(r'\d').hasMatch(value)) {
                    return 'Last Name should not contain numbers';
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
                      Navigator.pushNamed(context, '/sign_up/dob');
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
