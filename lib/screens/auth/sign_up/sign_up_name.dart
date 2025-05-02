import 'package:flutter/material.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';

class SignUpName extends StatefulWidget {
  const SignUpName({super.key});

  @override
  State<SignUpName> createState() => _SignUpNameState();
}

class _SignUpNameState extends State<SignUpName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                print('$field changed: $value');
              },
              validatorFunc: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your First Name';
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
                print('$field changed: $value');
              },
              validatorFunc: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Last Name';
                }
                return null;
              },
            ),

            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,

              child: Fab(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_up/dob');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
