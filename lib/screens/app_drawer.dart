
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/login_screen.dart';

class appDrawer extends StatefulWidget {
  const appDrawer({super.key});

  @override
  State<appDrawer> createState() => _appDrawerState();
}

class _appDrawerState extends State<appDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(

      backgroundColor: Color(0xff264653),
      child: ListView(
      padding: const EdgeInsets.only(top: 30),
      children: [
       DrawerHeader(
        decoration: BoxDecoration(
          color: Color(0xff2a9d8f),
         image: DecorationImage(
                  image: AssetImage('assets/Sushi cook-pana.png'), 
                  fit: BoxFit.scaleDown)
              ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
          ),
        ),

        // My Profile
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
          // colors 
          tileColor: Color(0xffe9c46a),
          iconColor: Color(0xff264653),
          textColor: Color(0xff264653),

          // icon 
          leading: const Icon(Icons.account_box_rounded, size: 30,),

          // text
          title: const Text('My Profile', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

          // back_end handle
          onTap: () {   
            Navigator.pushNamed(context, '/ProfilePage');     
          },
          ),
        ),

        // Messages 
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
          // colors 
          tileColor: Color(0xffe9c46a),
          iconColor: Color(0xff264653),
          textColor: Color(0xff264653),

          // icon 
          leading: const Icon(Icons.message_sharp, size: 30,),

          // text
          title: const Text('Messages', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

          // back_end handle
          onTap: () {   
                 
          },
          ),
        ),

         // Hired Services
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
          // colors 
          tileColor: Color(0xffe9c46a),
          iconColor: Color(0xff264653),
          textColor: Color(0xff264653),

          // icon 
          leading: const Icon(Icons.room_service_rounded, size: 30,),

          // text
          title: const Text('Hired Services', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

          // back_end handle
          onTap: () {   
             
          },
          ),
        ),

         // quotes
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(
          // colors 
          tileColor: Color(0xffe9c46a),
          iconColor: Color(0xff264653),
          textColor: Color(0xff264653),

          // icon 
          leading: const Icon(Icons.event_available_outlined, size: 30,),

          // text
          title: const Text('quotes', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

          // back_end handle
          onTap: () {   
             
          },
          ),
        ),






      
        // Settings 
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ListTile(

          // colors 
          tileColor: Color(0xffe9c46a),
          iconColor: Color(0xff264653),
          textColor: Color(0xff264653),

          // icon 
          leading: const Icon(Icons.settings, size: 30,),

          // text
          title: const Text('Settings', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

          // back_end handle
          onTap: () {           
           
          },
          ),
        ),

        // Logout 
        ListTile(

        // colors 
        tileColor: Color(0xffe9c46a),
        iconColor: Color(0xff264653),
        textColor: Color(0xff264653),

        // icon 
        leading: const Icon(Icons.logout, size: 30,),

        // text
        title: const Text('logout', style: TextStyle(color: Color(0xff264653), fontSize: 18 , fontFamily: 'Mulish-Bold' , decoration: TextDecoration.none,)),

        // back_end handle
        onTap: () {
          
          logout(context);

          },
         ),
        ],
      ),   
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}