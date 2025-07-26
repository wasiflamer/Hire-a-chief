
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/catering_profile.dart';
import 'package:hire_a_chef/screens/chef_profile.dart';
import 'package:hire_a_chef/screens/contact_us.dart';
import 'package:hire_a_chef/screens/home_screen.dart';
import 'package:hire_a_chef/screens/custom_profile.dart';
import 'package:hire_a_chef/screens/login_screen.dart';
import 'package:hire_a_chef/screens/registration_screen.dart';
import 'package:hire_a_chef/screens/search_catering.dart';
import 'package:hire_a_chef/screens/search_chef.dart';
import 'package:hire_a_chef/screens/search_gigs.dart';
import 'package:hire_a_chef/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future <void> main() async {  

 // binding initialization for async 
 WidgetsFlutterBinding.ensureInitialized();

// initailize Firebase
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

runApp(MaterialApp(
  
  debugShowCheckedModeBanner: false,
  title: 'Hire a Chef',
  initialRoute: '/',
   
  // availble routes in the app 
  routes: {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
    '/signin': (context) => const RegistrationScreen(),
    '/homescreen': (context) => const HomeScreen(),
    '/findChef': (context) => const searchChef(),
    '/findcatering': (context) => const searchCatering(),
    '/findgigs': (context) => const searchGigs(),
    '/contactus': (context) => const contactUs(),
    '/ProfilePage': (context) => customProfile(),
    '/ChefProfile': (context) => chefProfile(),
    '/CateringfProfile': (context) => cateringProfile(), 
  },
));
}

// snackbar function [ to get snackbar ]
SnackBar getSnack (String msg, dynamic type, String title ) {
  return SnackBar(
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  backgroundColor: Colors.transparent,
  content: AwesomeSnackbarContent(
    title: title,
    message:
        msg,
    contentType: type,
  ));
}