import 'package:flutter/material.dart';
import '../screens/inbox/chat.dart';
import '../screens/auth/sign_up/sign_up.dart';
import '../screens/auth/sign_up/sign_up_email.dart';
import '../screens/auth/sign_up/sign_up_name.dart';
import '../screens/auth/sign_up/sign_up_dob.dart';
import '../screens/auth/sign_up/sign_up_password.dart';
import '../screens/auth/login.dart';
import '../screens/home.dart';
import '../screens/profile/about_you/personal_details.dart';
import '../screens/profile/about_you/mini_bio.dart';
import '../screens/profile/about_you/travel_preferences.dart';
import '../screens/profile/about_you/add_vehicle.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/sign_up':
      return MaterialPageRoute(builder: (_) => SignUp());
    case '/sign_up/email':
      return MaterialPageRoute(builder: (_) => SignUpEmail());
    case '/sign_up/name':
      return MaterialPageRoute(builder: (_) => SignUpName());
    case '/sign_up/dob':
      return MaterialPageRoute(builder: (_) => SignUpDob());
    case '/sign_up/password':
      return MaterialPageRoute(builder: (_) => SignUpPassword());
    case '/login':
      return MaterialPageRoute(builder: (_) => Login());
    case '/home':
      return MaterialPageRoute(builder: (_) => Home());
    case '/about_you/personal_details':
      return MaterialPageRoute(builder: (_) => PersonalDetails());
    case '/about_you/mini_bio':
      return MaterialPageRoute(builder: (_) => MiniBio());
    case '/about_you/travel_preferences':
      return MaterialPageRoute(builder: (_) => TravelPreferences());
    case '/about_you/add_vehicle':
      return MaterialPageRoute(builder: (_) => AddVehicle());
    case '/inbox/chat':
      final name = settings.arguments as String;
      return MaterialPageRoute(builder: (_) => Chat(name: name));
    default:
      return MaterialPageRoute(
        builder:
            (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
      );
  }
}
