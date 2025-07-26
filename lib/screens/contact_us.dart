
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

double buttom_padding = 0 ;
double top_padding    = 0 ; 

class contactUs extends StatelessWidget {
  const contactUs({super.key});

  @override
  Widget build(BuildContext context) {

  
   double screen_width =  MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio;

   if (screen_width <= 1080.0 )
   {
       buttom_padding = 80 ;
       top_padding = 100 ;  
   }
   else if ( screen_width > 1080.0 )
   {
       buttom_padding = 120 ;
       top_padding = 150;
   }
  
   
    return MaterialApp(

      // to remove debug banner 
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          shape: const   RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(
          bottomRight:   Radius.circular(0),
          bottomLeft:    Radius.circular(0),  
          ),
          ),

          title: Row(   
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

          Container(
            margin: const EdgeInsets.all(0),
            child  : ElevatedButton(
            onPressed: () {

              // go to homescreen
              Navigator.pushNamed(context,'/homescreen');

            },
            style: ElevatedButton.styleFrom(
            foregroundColor: (Color(0xff264653)),
            backgroundColor: (Color(0xffe9c46a)),
            shape: const CircleBorder(),
            
            ),
            child: const Icon(Icons.arrow_back_sharp),
          ),

          ),

          Container(
          padding: const EdgeInsets.only(right: 60), child: const Text('Contact Us', style: TextStyle(fontSize: 25.0 , fontFamily: 'Russo One', ))) 
          ],   
          ), 
          ),

          body: Container(   

          decoration: const BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/background/pattern_2/image.jpg"),
          fit: BoxFit.none,
          ),
          ),

          child: Center(
          child: Card(
          color: Color(0xff264653),
          
          shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.all( Radius.circular(10)),
          ),

          margin: EdgeInsets.only(bottom: buttom_padding , top: top_padding ),
  
          elevation: 10,
          child: Column(
            
            children: [
              SizedBox(
              width: 300,
              height: 150,

              child:  Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.only( topLeft:Radius.circular(10) , topRight:Radius.circular(10)),
              image: DecorationImage(
              image: AssetImage("assets/cover.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              ),
              ), 
              ),
              ),

              SizedBox(

              width: 300,
              height: 440,
              child:  Column(
                children: [
                  Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.only( bottomLeft:Radius.circular(10) , bottomRight:Radius.circular(10)),
                  color: (Color(0xff264653)),
                  ),

                  child: Align(
                  
                  alignment: Alignment.topLeft ,
                  child: Padding(padding: EdgeInsets.all(10),
                  child: ListTile(
                  tileColor: (Color(0xff3d405b)),
                  title: Text('Hire A Chef', style: TextStyle(color: Colors.white , fontSize: 20 , fontFamily: 'Mulish-Bold'),),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('''Welcome to our app that connects you with top-notch chef and catering companies for your hiring needs. We are dedicated to providing an easy and efficient way for you to find the perfect catering solution for your events, whether it be a small family gathering or a large corporate event, Booking a chef or catering company through our app is simple and straightforward. Simply provide us with the details of your event, such as date, location, and number of guests,\n\nNote : All the illustrations are taken from Storyset and the credit goes to the respective others''',
                    style: TextStyle(color: Colors.white70 , fontSize: 16 , fontFamily: 'sans'),),
                  ),
                  ),
                  ),
                  ),
                  ),
                ],
              ),
              ),
            ],
          ),
          ),
        ),
        ),

      extendBodyBehindAppBar: true,  
        
    ),
    );
      
  }
}