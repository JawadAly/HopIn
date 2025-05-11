import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopin/screens/publishjourney/passengercounter.dart';
import 'package:hopin/screens/publishjourney/traveldate.dart';
import 'package:hopin/screens/publishjourney/traveltime.dart';
import 'package:toastification/toastification.dart';
import 'package:hopin/screens/publishjourney/dropoff.dart';
import 'package:hopin/screens/publishjourney/pickup.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'package:hopin/screens/publishjourney/routedecider.dart';
import 'package:provider/provider.dart';
import './screens/spashscreen.dart';
import 'screens/auth/sign_up/sign_up.dart';
import 'screens/auth/sign_up/sign_up_email.dart';
import 'screens/auth/sign_up/sign_up_name.dart';
import 'screens/auth/sign_up/sign_up_dob.dart';
import 'screens/auth/sign_up/sign_up_password.dart';
import 'screens/auth/login.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Publishridemodel())],
      child: ToastificationWrapper(child: MyApp()),
    ),
  );
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
        //publish-rides routes
        '/publishride': (context) => Pickup(),
        '/publishride/dropoff': (context) => Dropoff(),
        '/publishride/routedecider': (context) => Routedecider(),
        '/publishride/traveldate': (context) => Traveldate(),
        '/publishride/traveltime': (context) => Traveltime(),
        '/publishride/passengercounter': (context) => Passengercounter(),
        //sign-up journey routes
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
