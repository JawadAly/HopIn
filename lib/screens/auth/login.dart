import 'package:flutter/material.dart';
import '../../widgets/input.dart';
import 'package:hopin/widgets/button.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _userLoginGlobalKey = GlobalKey<FormState>();
  Map<String, String> loginUserCreds = {"Email": "", "Password": ""};
  void userCredentialsModifier(String inputName, String incomingVal) {
    setState(() {
      loginUserCreds[inputName] = incomingVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What's your email and password?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Form(
              key: _userLoginGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Input(
                    keyboardType: TextInputType.emailAddress,
                    hint: "Email",
                    textObscure: false,
                    changeSenseFunc: userCredentialsModifier,
                    validatorFunc: (incomingVal) {
                      return incomingVal.isEmpty || incomingVal == null
                          ? "Email is a required field!"
                          : null;
                    },
                  ),
                  SizedBox(height: 20),
                  Input(
                    keyboardType: TextInputType.text,
                    hint: "Password",
                    textObscure: true,
                    changeSenseFunc: userCredentialsModifier,
                    validatorFunc: (incomingVal) {
                      return incomingVal.isEmpty ||
                              incomingVal == null && incomingVal.length > 30
                          ? "Password must be maximum of 30 characters!"
                          : null;
                    },
                    maxLength: 30,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
