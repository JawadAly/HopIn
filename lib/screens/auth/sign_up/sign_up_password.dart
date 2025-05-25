import 'package:flutter/material.dart';
import 'package:hopin/screens/auth/auth_service.dart';
import 'package:hopin/widgets/fab.dart';
import 'package:hopin/widgets/input.dart';
import 'package:provider/provider.dart';
import 'package:hopin/data/providers/user_info_provider.dart';
import 'package:hopin/apiservices/authServices/user_api_service.dart';

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
                validatorFunc: (value) => passwordValidation(value),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,

                child: Fab(onPressed: userRegistration),
              ),
            ],
          ),
        ),
      ),
    );
  }

  passwordValidation(value) {
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
  }

  userRegistration() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = context.read<UserInfoProvider>();
      final auth = authService.value;
      final api = UserApiService();

      try {
        // Step 1: Register on Firebase
        await auth.signUp(
          email: userProvider.email,
          password: userProvider.password,
        );

        userProvider.updateUserId(value: auth.currentUser!.uid);

        // Step 2: Register on your own API
        await api.registerUser(userProvider.getUserInfo());

        // Step 3: Navigate to home if both succeed
        if (!mounted) return;
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        print('Error: $e');

        // Rollback Firebase user
        try {
          await authService.value.deleteAccount(
            email: userProvider.email,
            password: userProvider.password,
          );
        } catch (deleteError) {
          print('Rollback failed: $deleteError');
        }
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      userProvider.printInfo();
    }
  }
}
