import 'package:flutter/material.dart';
import 'package:hopin/models/ride.dart';
import 'package:hopin/screens/myRides/ride_details_page.dart';
import 'package:hopin/screens/publishjourney/dropoff.dart';
import 'package:hopin/screens/publishjourney/journeyfinalizer.dart';
import 'package:hopin/screens/publishjourney/passengercounter.dart';
import 'package:hopin/screens/publishjourney/pickup.dart';
import 'package:hopin/screens/publishjourney/pricing.dart';
import 'package:hopin/screens/publishjourney/routedecider.dart';
import 'package:hopin/screens/publishjourney/traveldate.dart';
import 'package:hopin/screens/publishjourney/traveltime.dart';
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
    case '/publishride':
      return MaterialPageRoute(builder: (_) => Pickup());
    case '/publishride/dropoff':
      return MaterialPageRoute(builder: (_) => Dropoff());
    case '/publishride/routedecider':
      return MaterialPageRoute(builder: (_) => Routedecider());
    case '/publishride/traveldate':
      return MaterialPageRoute(builder: (_) => Traveldate());
    case '/publishride/traveltime':
      return MaterialPageRoute(builder: (_) => Traveltime());
    case '/publishride/passengercounter':
      return MaterialPageRoute(builder: (_) => Passengercounter());
    case '/publishride/pricing':
      return MaterialPageRoute(builder: (_) => Pricing());
    case '/publishride/finalize':
      return MaterialPageRoute(builder: (_) => Journeyfinalizer());

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
    case '/ride/details':
      final args = settings.arguments as Map<String, dynamic>;
      final ride = args['ride'] as Ride;
      final bool fromSearchResults = args['fromSearchResults'] ?? false;
      final bool fromMyRides = args['fromMyRides'] ?? false;
      return MaterialPageRoute(
        builder:
            (_) => RideDetailsPage(
              ride: ride,
              fromSearchResults: fromSearchResults,
              fromMyRides: fromMyRides,
            ),
      );

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
