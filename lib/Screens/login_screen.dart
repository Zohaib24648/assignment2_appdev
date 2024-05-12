import 'package:flutter/material.dart';
import '../components/auth.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  LoginScreen({Key? key}) : super(key: key);

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _auth.signInWithGoogle();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
            );
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
//24648