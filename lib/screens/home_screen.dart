
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_a_chef/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/app_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hire_a_chef/screens/search_catering.dart';
import 'package:hire_a_chef/screens/search_chef.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  

  // get all chefs 
  Future <dynamic> getALLChef() async {
  dynamic _collectionRef = 
  FirebaseFirestore.instance.collection('users').where("account_type",isEqualTo: "Chef");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
  } 

   
  Future <dynamic> getAllcompanies() async {
  dynamic _collectionRef = 
  FirebaseFirestore.instance.collection('users').where("account_type",isEqualTo: "Catering Company");
  // Get docs from collection reference
  QuerySnapshot querySnapshot = await _collectionRef.get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

  dynamic homeTextstyle = TextStyle(color: Color(0xff264653), fontSize: 14, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis);
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();  
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());  

       // get the current device token and send it to firestore docuemnt 
     FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
     _firebaseMessaging.getToken().then((token)  {
      print("token is $token");
      
      var db =  FirebaseFirestore.instance;
      var token_id = {"token_id": token};
      db.collection("users").doc("${loggedInUser.uid}").set(token_id, SetOptions(merge: true)); 
      
    });
      setState(() {});
          
    });  
     
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: appDrawer(),

      // keybaord poping fix
      resizeToAvoidBottomInset: false,

      body: NestedScrollView(
       physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          
          return <Widget> [
              SliverAppBar(  
                title: Text('Hire A Chef', style: TextStyle(fontFamily: 'Russo One', color: Color(0xffffffff), fontSize: 24)),
                bottom: AppBar(
                  leading: Container(),
                  toolbarHeight: 120,
                    backgroundColor: const Color(0xff2a9d8f), 
                    flexibleSpace: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [SizedBox(width: 90, height: 100, child: ListTile( onTap: () { Navigator.pushNamed(context, '/findChef');     }, title: Column(children: [ Image.asset('assets/chef_icon.png'),Text("Chef", style: homeTextstyle)])))]),
                          Column(children: [SizedBox(width: 91, height: 100, child: ListTile( onTap: () { Navigator.pushNamed(context, '/findcatering'); }, title: Column(children: [ Image.asset('assets/catering_service.png'),Text('Catering',style: homeTextstyle)])))]),
                          Column(children: [SizedBox(width: 90, height: 100, child: ListTile( onTap: () { Navigator.pushNamed(context, '/findgigs');     }, title: Column(children: [ Image.asset('assets/gigs.png'),Text('Gigs', style: homeTextstyle)])))]),
                          Column(children: [SizedBox(width: 90, height: 100, child: ListTile( onTap: () { Navigator.pushNamed(context, '/contactus');    }, title: Column(children: [ Image.asset('assets/contact.png'),Text('Contact', style: homeTextstyle)])))]),
                        ],

                      ),
                      ),
                    ),

                  elevation: 8,
                  forceElevated: true,                  
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: const Color(0xff2a9d8f),
                  foregroundColor: Colors.white,
                  expandedHeight: 100.0,
                  flexibleSpace:  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                  ),
                ),
              ];
            },

            body: 

                // discover    
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        
                        // discover
                        ListTile(
                        title: Container(
                          decoration: BoxDecoration(                 
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(30),     
                          child: Text('Discover', style: TextStyle(color: Colors.white , fontFamily: 'Mulish-Bold', fontSize: 28),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                          // All Chefs 
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color:  Color(0xffe9c46a),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(10),     
                          child: Text('All Chefs', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                         // scrollable list
                         FutureBuilder<dynamic>(
                         future: getALLChef(),
                         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return CircularProgressIndicator(color: Colors.teal,);
                            default:
                              if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                              else 
                              return 
                              ListTile(
                              subtitle: SizedBox(
                              height: 300,
                              child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              reverse: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/ChefProfile', arguments: ScreenArguments(snapshot.data[index]['uid'],snapshot.data[index]['token_id'] ?? 'null' , loggedInUser.uid ));
                                },
                                child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.black87,
                                    color: Color(0xff264653),
                                    child: SizedBox(
                                      width: 150,
                                      height: 210,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                          Image.network( snapshot.data[index]['profile_photo'].toString() != 'null' ? snapshot.data[index]['profile_photo'].toString() : 'https://images.pexels.com/photos/593158/pexels-photo-593158.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', fit: BoxFit.fitHeight, height: 240,),
                                          Text(snapshot.data[index]['firstName'], style: homeTiletext,),
                                      ],
                                      ), 
                                      ), 
                                    ), 
                                 ),
                              );
                            },                        
                            ),
                            ),
                            );
                            }
                          },
                         ),
                               
                          // Catering Companies heading  
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color:  Color(0xffe9c46a),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(10),     
                          child: Text('Catering Companies', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                         // scrollable list catering companies
                         FutureBuilder<dynamic>(
                         future: getAllcompanies(),
                         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return CircularProgressIndicator(color: Colors.teal,);
                            default:
                              if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                              else 
                              return 
                              ListTile(
                              subtitle: SizedBox(
                              height: 250,
                              width: 300,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/CateringfProfile', arguments: ScreenArguments_catering(snapshot.data[index]['uid'], snapshot.data[index]['token_id'] ?? 'null'));
                                    },
                                    child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.black87,
                                    color: Color(0xff264653),
                                    child: SizedBox(
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                          Image.network( snapshot.data[index]['profile_photo'].toString() != 'null' ? snapshot.data[index]['profile_photo'].toString() : 'https://images.pexels.com/photos/593158/pexels-photo-593158.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1', fit: BoxFit.fitHeight, height: 100, width: 300,),
                                          Text(snapshot.data[index]['firstName'] + ' ' + snapshot.data[index]['secondName'], style: homeTiletext,),
                                      ],
                                      ), 
                                      ), 
                                    ), 
                                 ),
                              );}),
                            ),
                            );
                            }
                          },
                         ),

                          ],
                        ),
                      ),
                    ),
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



dynamic homeTiletext = TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis);

