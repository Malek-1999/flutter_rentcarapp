import 'package:flutter/material.dart';
import 'package:flutter_rentcarapp/auth/loginPage.dart';
import 'package:flutter_rentcarapp/auth/signUpPage.dart';
import 'package:flutter_rentcarapp/constants/constants.dart';
import 'package:flutter_rentcarapp/firebase_options.dart';
import 'Views/showroom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental app',
      theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(),
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => Showroom(),
      },
    );
  }
}
