import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/auth_widget.dart';
import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';
import 'Screens/welcome_screen.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
      ),
      // Initial route
      initialRoute: '/',
      routes: {
        '/': (context) =>  AuthWidget(
          signedInBuilder: (context) =>  WelcomeScreen(),
          nonSignedInBuilder: (context) => const HomeScreen(),
        ),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
      },
    );
  }
}
//24648