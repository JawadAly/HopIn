import 'package:flutter/material.dart';
import 'package:hopin/widgets/input.dart';
import 'package:hopin/widgets/fab.dart';

class SignUpEmail extends StatefulWidget {
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SignUpEmail> {
  bool? isReceiveEmailChecked = false;

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
                "What's your email?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Input(
              keyboardType: TextInputType.emailAddress,
              hint: "Email",
              textObscure: false,
              changeSenseFunc: (field, value) {
                print('$field changed: $value');
              },
              validatorFunc: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Checkbox(
                  value: isReceiveEmailChecked,
                  onChanged: (value) {
                    setState(() {
                      isReceiveEmailChecked = value;
                    });
                  },
                ),
                Flexible(
                  child: const Text(
                    'I want to receive special offers and personalized recommendation via email',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Fab(
                onPressed: () => Navigator.pushNamed(context, '/sign_up/name'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
