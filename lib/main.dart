import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/spashscreen.dart';
import 'screens/auth/sign_up/sign_up.dart';
import 'screens/auth/sign_up/sign_up_email.dart';
import 'screens/auth/sign_up/sign_up_name.dart';
import 'screens/auth/sign_up/sign_up_dob.dart';
import 'screens/auth/sign_up/sign_up_password.dart';
import 'screens/auth/login.dart';
import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HopIn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 110, 78, 163),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Splashscreen(),
      routes: {
        '/sign_up': (context) => SignUp(),
        '/sign_up/email': (context) => SignUpEmail(),
        '/sign_up/name': (context) => SignUpName(),
        '/sign_up/dob': (context) => SignUpDob(),
        '/sign_up/password': (context) => SignUpPassword(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
      },
    );
  }
}
