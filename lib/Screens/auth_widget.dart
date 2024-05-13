import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWidget extends StatelessWidget {
  final Widget Function(BuildContext) signedInBuilder;
  final Widget Function(BuildContext) nonSignedInBuilder;

  const AuthWidget({
    Key? key,
    required this.signedInBuilder,
    required this.nonSignedInBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return signedInBuilder(context);  // User is signed in
        } else {
          return nonSignedInBuilder(context);  // User is not signed in
        }
      },
    );
  }
}