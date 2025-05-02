import 'package:flutter/material.dart';
import 'package:hopin/widgets/button.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.asset(
                  'assets/images/auth_image.jpeg',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Your pick of rides at low prices!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: authButton(
                  "Sign Up",
                  Color.fromARGB(255, 110, 78, 163),
                  Colors.white,
                  () => Navigator.pushNamed(context, '/sign_up'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: authButton(
                  "Sign In",
                  Colors.white,
                  Color.fromARGB(255, 110, 78, 163),
                  () => Navigator.pushNamed(context, '/login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget authButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
