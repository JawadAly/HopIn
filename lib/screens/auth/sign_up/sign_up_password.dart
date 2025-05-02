import 'package:flutter/material.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';

class SignUpPassword extends StatefulWidget {
  const SignUpPassword({super.key});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
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
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
