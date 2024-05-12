import 'package:assignment2_appdev/Screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:assignment2_appdev/components/components.dart';
import 'package:assignment2_appdev/Screens/login_screen.dart';
import 'package:assignment2_appdev/Screens/signup_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  void handlegoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      print(e);
    }
  }

  void handleSignOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const TopScreenImage(screenImageName: 'home.jpg'),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const ScreenTitle(title: 'Hello'),
                    // const Text(
                    //   'Welcome to Tasky, where you manage your daily tasks',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 20,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Hero(
                      tag: 'login_btn',
                      child: CustomButton(
                        buttonText: 'Login',
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Hero(
                      tag: 'signup_btn',
                      child: CustomButton(
                        buttonText: 'Sign Up',
                        isOutlined: true,
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'Sign up using',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            handlegoogleSignIn();
                          },
                          icon:  const Icon(
                            EvaIcons.google,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon:  const Icon(
                            EvaIcons.facebook,
                            color: Colors.blue,
                          ),),
                        IconButton(
                          onPressed: () {print('Twitter');},
                          icon: const Icon(
                            Icons.facebook ),)
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
