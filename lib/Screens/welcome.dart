import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment2_appdev/components/components.dart';

import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child:  Center(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Welcome'),
            ),
            body: Center(
              child: Column(
                children: [
                  Text('Welcome to Tasky, where you manage your daily tasks'),
                  ElevatedButton(
                    onPressed: () {

                      },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),



          )
        ),
      ),
    );
  }
}
