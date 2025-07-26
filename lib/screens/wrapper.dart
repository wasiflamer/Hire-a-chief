
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/home_screen.dart';
import 'package:hire_a_chef/screens/login_screen.dart';
import 'auth.dart';

class wrapper extends StatefulWidget {
  const wrapper({super.key});

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen(); 
        }
      }
    );
  }
}