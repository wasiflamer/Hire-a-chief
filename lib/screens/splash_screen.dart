
import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer( const
        Duration(seconds: 0),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>  const wrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(

         decoration: const BoxDecoration(
          color: Colors.white,
          ),

        //logo image 
        child: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              Image.asset('assets/logo.png', height: 200,),
              const Padding(padding:  EdgeInsets.all(8.0) , child: Text('Hire A Chef' , style: TextStyle(fontFamily: 'Russo One', color: Color(0xff264653), fontSize: 24)),)
            ],
          ),

        ),
      ),
    );
  }
}


