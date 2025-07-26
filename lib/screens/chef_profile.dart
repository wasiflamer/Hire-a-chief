
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/main.dart';
import 'package:hire_a_chef/screens/custom_profile.dart';
import 'package:hire_a_chef/screens/search_chef.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:awesome_number_picker/awesome_number_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class chefProfile extends StatefulWidget {
  const chefProfile({super.key});

  @override
  State<chefProfile> createState() => _chefProfileState();
}

class _chefProfileState extends State<chefProfile> {

 
  // innit state 
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), (() {
      setState(() {});
    }));
  } 

  @override
  Widget build(BuildContext context) {

      // extract arguments with modalroute
      final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

      // for button logic 
      bool   isAlreadyHired = false ; 
      Icon   buttonicon   = Icon(Icons.shopping_cart, size: 30); 
      String buttontext   = 'Hire';

      // button logic check if the request has already been made and is pending ??? 
      dynamic db = FirebaseFirestore.instance ;  
      final docRef =  db.collection("users").doc(args.user_uid);
      docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data["sent_requests"].toString() != 'null' ) {

          var n = data['sent_requests'].length;
          for (var i = 0; i < n; i++) {

            if (data['sent_requests'][i]['receiver'].toString() == args.uid) {
              isAlreadyHired = true ;
              buttontext = 'Request Send';
              buttonicon = Icon(Icons.check_circle, size: 30);
             
              return ;         
            }
            else
            {
              
              
            }
          }

        }             
        },
          onError: (e) => print("Error getting document: $e"),
        );
      

      // get searched data of specific chef from database
      Future <dynamic> getChefdetails(String uid) async {
    
      dynamic _collectionRef = 
      FirebaseFirestore.instance.collection('users').where("account_type", isEqualTo: "Chef").where("uid", isEqualTo : args.uid);
      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.get();
      // Get data from docs and convert map to List
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
      }


    Future <void> _dialogBuilder(BuildContext context) {
    TextEditingController locationtextcontroller = TextEditingController();
    TextEditingController infotextcontroller     = TextEditingController();
    dynamic dateTime ;
    dynamic total_dishes ; 
    dynamic meals ; 
    dynamic total_people ; 
    dynamic location ;
    dynamic info ; 

    return showDialog<void>(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
          title:  ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Container(
              color: Colors.teal,              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Request a Quote', style: about_heading, textAlign: TextAlign.center,),
              )),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [     

                // date and time
                Text('Pick Date and Time', style: about_heading,),
                ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffe9c46a)) , foregroundColor: MaterialStatePropertyAll(Color(0xff264653),)), onPressed: () async {
                   dateTime = await showOmniDateTimePicker(context: context , primaryColor: Colors.teal);
                }, child: Text('Select Here')),
          
                // how many dishes to be made
                Text('How Many Dishes', style: about_heading,),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: IntegerNumberPicker(pickedItemTextStyle: about_heading ,  pickedItemDecoration: BoxDecoration(color: Color(0xffe9c46a),) , otherItemsDecoration: BoxDecoration(color: Color(0xffe9c46a),), otherItemsTextStyle: about_heading, size: 40.0,  axis: Axis.horizontal , minValue: 1 , maxValue: 11, initialValue: 1, onChanged: (value) {   
                   total_dishes  = value ;  
                  },),
                ),
          
                // how many meals are to be prepared
                Text('How Many Meals' , style: about_heading,),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: IntegerNumberPicker(pickedItemTextStyle: about_heading ,  pickedItemDecoration: BoxDecoration(color: Color(0xffe9c46a),) , otherItemsDecoration: BoxDecoration(color: Color(0xffe9c46a),), otherItemsTextStyle: about_heading, size: 40.0,  axis: Axis.horizontal , minValue: 1 , maxValue: 11, initialValue: 1, onChanged: (value) {   
                   meals  = value ;  
                  },),
                ),
          
                 // for how many people
                Text('How many people' , style: about_heading,),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: IntegerNumberPicker(pickedItemTextStyle: about_heading ,  pickedItemDecoration: BoxDecoration(color: Color(0xffe9c46a),) , otherItemsDecoration: BoxDecoration(color: Color(0xffe9c46a),), otherItemsTextStyle: about_heading, size: 40.0,  axis: Axis.horizontal , minValue: 1 , maxValue: 11, initialValue: 1, onChanged: (value) {   
                   total_people  = value ;  
                  },),
                ),
          
                // Location
                Text('Enter Location', style: about_heading,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.teal,
                    style: more_info_text,
                    controller: locationtextcontroller,
                    onChanged: (value) {
                       location = value ; 
                    },                        
                  ),
                ),

                // info
                Text('Details', style: about_heading,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.teal,
                    controller: infotextcontroller,
                    onChanged: (value) {
                       info = value ; 
                    },                        
                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Send'),
              onPressed: () {

                // initializing db 
                dynamic db = FirebaseFirestore.instance;
      
                // get all the form info 
                dynamic detail_class = quote_form_details(dateTime,total_dishes, total_people, meals, location, info);
 
                // setting sent_request
                final data = {
                  "sent_requests" : FieldValue.arrayUnion([{ 
                    "sender"      : args.user_uid,
                    "receiver"    : args.uid, 
                    "status"      : "pending",
                    "details"  :  {
                    "date"              :  detail_class.datetime, 
                    "total_dishes"      :  detail_class.total_dishes,                     
                    "total_people"      :  detail_class.total_people,
                    "meals"             :  detail_class.meals, 
                    "location"          :  detail_class.location,
                    "info"              :  detail_class.info,

                     }  
                  }]), 
                };

                // setting received_request
                final data_2 = {
                  "received_request" : FieldValue.arrayUnion([{ 
                    "sender"   :  args.user_uid,
                    "receiver" :  args.uid,
                    "status"   : "pending",
                    "details"  :  {
                    "date"              :  detail_class.datetime, 
                    "total_dishes"      :  detail_class.total_dishes,                     
                    "total_people"      :  detail_class.total_people,
                    "meals"             :  detail_class.meals, 
                    "location"          :  detail_class.location,
                    "info"              :  detail_class.info,
                     }  
                  }]), 
                };

                // sending sent_request to the database
                db.collection("users").doc(args.user_uid).set(data, SetOptions(merge: true));  

                // sending received_request to the database
                db.collection("users").doc(args.uid).set(data_2, SetOptions(merge: true));

                // send push notification / msg to notify the user that they should check quotes tab 

                


                
                      
                // show snackbar
                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(getSnack('', ContentType.success, 'Quote Sent !'));
                

                // back to chef screen 
                Navigator.of(context).pop();

                setState(() {});
              },
            ),
          ],
        );
      },
    );
}
    
    return Scaffold(

      // keybaord poping fix
      resizeToAvoidBottomInset: false,

      body: NestedScrollView(
       physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget> [
                  SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                  background: FutureBuilder<dynamic>(
                        future: getChefdetails(args.uid),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return Text('Loading....');
                            default:
                              if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                              else
                              return snapshot.data[0]['profile_photo'].toString() != 'null' ? Image.network(snapshot.data[0]['profile_photo'].toString(), fit: BoxFit.fitHeight,) : defaultImage();
                            }
                          },
                        ),
                      ),
  
                  elevation: 8,
                  forceElevated: true,                  
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: Color(0xff264653),
                  foregroundColor: Colors.white,
                  expandedHeight: 280.0,
             ),
          ];
        },       

        body: Padding(
              padding: const EdgeInsets.all(8.0),
                // fetch details
                child: FutureBuilder<dynamic>(
                future: getChefdetails(args.uid),
                builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot,
                ) {
                
                // data is loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.teal,));
                }  
                              
                // return details
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ 
                
                      // name container        
                      Container(
                        decoration: BoxDecoration(             
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                        ),
                        child: ListTile(
                        leading: Icon(Icons.male,size: 35, color: Colors.white,),
                        title: Text(snapshot.data[0]['firstName'] + ' ' + snapshot.data[0]['secondName'] , style: detailstextstyle,),
                        subtitle: Text('Free', style: TextStyle(color: Colors.white , fontFamily: 'Mulish')),
                        ),
                      ),

                      // About Container        
                      Padding(
                        padding: const EdgeInsets.only(top: 8 , bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(             
                            color: Color(0xff264653),
                            borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          child: ListTile(
                          leading: Icon(Icons.info,size: 35, color: Colors.white,),
                          title: Text('About', style: detailstextstyle,),
                          minVerticalPadding: 10,
                          subtitle: Text('likes to make traditional dishes, ranging from pakistani to british', style: TextStyle(color: Colors.white , fontFamily: 'Mulish')),
                          ),
                        ),
                      ),
                        
                      // Blogs Published  
                      ListTile(
                      title: Container(
                      decoration: BoxDecoration(                 
                      color:  Color(0xffe9c46a),
                      borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                      ),
                      padding: EdgeInsets.all(10),     
                      child: Text('Blogs Published', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,             
                      )
                      ),
                      ),
                
                      // scrollable list-tile
                      ListTile(
                      title: SizedBox(
                      height: 210,
                      child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 10,
                        color: Colors.white,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network("https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                          ),
                        );
                        },                        
                        ),
                        ),
                        ),
                
                        // Dishes Deliveres
                        ListTile(
                        title: Container(
                        decoration: BoxDecoration(                 
                        color:  Color(0xffe9c46a),
                        borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                        ),
                        padding: EdgeInsets.all(10),     
                        child: Text('Dishes Deliveres', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,             
                        ),
                        ),
                        ),

                      // scrollable list-tile
                      ListTile(
                      title: SizedBox(
                      height: 210,
                      child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 10,
                        color: Colors.white,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network("https://images.pexels.com/photos/1267320/pexels-photo-1267320.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                          ),
                        );
                        },                        
                        ),
                        ),
                        ),

                        // contact container
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(             
                            color: Color(0xff264653),
                            borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          child: ListTile(
                          title: Text('Contact info',style: detailstextstyle_small, textAlign: TextAlign.center,),
                          subtitle: Text(snapshot.data[0]['email'], style:detailstextstyle_small, textAlign: TextAlign.center,),
                          ),
                        ),
                      ),

                      ClipRRect(borderRadius: BorderRadius.circular(36), child: Container(width: 300, child: ElevatedButton.icon(style: hirebutton,     onPressed: isAlreadyHired == false ? () async {await _dialogBuilder(context);} : null, icon: buttonicon, label: Text(buttontext, style: buttonstyle_)))),
                      ClipRRect(borderRadius: BorderRadius.circular(36), child: Container(width: 300, child: ElevatedButton.icon(style: messagebutton,  onPressed: () {}, icon: Icon(Icons.message, size: 30), label: Text('Message', style: buttonstyle_)))),
                      ClipRRect(borderRadius: BorderRadius.circular(36), child: Container(width: 300, child: ElevatedButton.icon(style: feedbackbutton, onPressed: () {}, icon: Icon(Icons.feedback, size: 30), label: Text('Give Feedback', style: buttonstyle_)))),
                          
                      // rating container 
                       Padding(
                         padding: const EdgeInsets.all(4.0),
                         child: Container(
                          width: 300,
                          decoration: BoxDecoration(             
                            color: Color(0xff264653),
                            borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          child: Center(
                            child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                           },
                          ),
                         ),
                        ),
                       ),
                      ],
                     ),
                    );
                  }),
                ),
              ),
            );
          }
        }

// text styles widgets 
TextStyle titleSearchstyle        = TextStyle(color: Color(0xff264653), fontSize: 25, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis,);
TextStyle detailstextstyle        = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis,);
TextStyle detailstextstyle_small  = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis,);
TextStyle buttonstyle_            = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis,);
TextStyle about_heading           = TextStyle(color: Color(0xff264653), fontSize: 20, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis,);
TextStyle more_info_text          = TextStyle(color: Color(0xff264653), fontSize: 18, fontFamily: 'Mulish', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis, decorationThickness: 0.0);

// buttons styles 
ButtonStyle hirebutton = ButtonStyle(
  backgroundColor: MaterialStatePropertyAll(Colors.green),
);

ButtonStyle messagebutton = ButtonStyle(
  backgroundColor: MaterialStatePropertyAll(Colors.purple[200]),
);

ButtonStyle feedbackbutton = ButtonStyle(
  backgroundColor: MaterialStatePropertyAll(Colors.blue),
);


class quote_form_details {
   
   dynamic datetime ; 
   dynamic total_dishes  ; 
   dynamic total_people  ;
   dynamic meals ; 
   dynamic location ;
   dynamic info ; 

   quote_form_details( this.datetime, this.total_dishes, this.total_people, this.meals, this.location , this.info); 

}