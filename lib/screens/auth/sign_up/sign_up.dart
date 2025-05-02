import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                "How do you want to sign up?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            customContainer(
              'Sign up with your email',
              Icon(Icons.email_outlined),
              () {
                Navigator.pushNamed(context, '/sign_up/email');
              },
            ),
            const SizedBox(height: 20),
            customContainer(
              'Continue with google',
              Icon(Icons.g_mobiledata_outlined),
              () {},
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text(
                "Already have an account?",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customContainer(String text, Icon icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_outlined),
          ],
        ),
      ),
    );
  }
}
