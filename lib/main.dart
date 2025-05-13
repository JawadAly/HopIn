import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopin/data/providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import './screens/spashscreen.dart';
import 'package:hopin/screens/publishjourney/publishridemodel.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Publishridemodel()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
      ],
      child: ToastificationWrapper(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
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
      onGenerateRoute: generateRoute,
    );
  }
}
