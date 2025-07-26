
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class customProfile extends StatefulWidget {
  const customProfile({super.key});

  @override
  State<customProfile> createState() => _customProfileState();
}

class _customProfileState extends State<customProfile> {

  // get the details of the current user 
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
 
  // innit state 
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });  

  } 

  // open gallery get the img then send it to cloud storage get the link too 
  _openGallery(dynamic uid) async {

  final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child("${loggedInUser.uid}/" + "profile_pic.jpg");
  UploadTask uploadTask = ref.putFile(File(image!.path));
  uploadTask.then((res) async {
   
  });
  
  // reset the state of widget
  setState(() {
  });
}

  Stream get_image() async* {  
  try {
    final storageRef = await FirebaseStorage.instance.ref().child("${loggedInUser.uid}/" + "profile_pic.jpg");
    final imageUrl = await storageRef.getDownloadURL();   
    yield imageUrl ;

    var db = await FirebaseFirestore.instance;
    var universal_profile_id = {"profile_photo": imageUrl};
    await db.collection("users").doc("${loggedInUser.uid}").set(universal_profile_id, SetOptions(merge: true)); 

  } on FirebaseException catch (e) {
    print("Failed with error '${e.code}': ${e.message}");

    var db = await FirebaseFirestore.instance;
    var universal_profile_id = {"profile_photo": null};
    await db.collection("users").doc("${loggedInUser.uid}").set(universal_profile_id, SetOptions(merge: true)); 
   
  }
  }

  @override
  Widget build(BuildContext context) {
    // code for the SliverAppBar 
    return Scaffold(     
      // keybaord poping fix
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget> [
              SliverAppBar(            
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                // future builder here for the image 
                background: StreamBuilder<dynamic>(
                          stream: get_image(),
                          builder: (
                              BuildContext context,
                              AsyncSnapshot<dynamic> snapshot,
                              ) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(color: Colors.orangeAccent,));
                            } else if (snapshot.connectionState == ConnectionState.active
                                || snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                  return Image.network(snapshot.data.toString(),fit: BoxFit.fitHeight,);
                              } else {
                                  return defaultImage();
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        ),
                ),
                bottom: AppBar(  
                  toolbarHeight: 70,
                  leading: Container(),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Align(alignment: Alignment.bottomRight, child: FloatingActionButton( backgroundColor: Color(0xffe9c46a), foregroundColor: Color(0xff264653), onPressed: () async { _openGallery(loggedInUser.uid); // reset the state of widget                    
                      Timer(Duration(seconds: 20), () {
                        setState(() {
                        });
                      });}, child: Icon(Icons.photo_size_select_actual_rounded))),
                    ),
                  ),
                elevation: 8,
                forceElevated: true,                  
                floating: true,
                pinned: false,
                snap: true,
                backgroundColor: const Color(0xff264653),
                foregroundColor: Colors.white,
                expandedHeight: 300.0,
                )];
                },

                // the actual body 
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                  
                        // Account Type
                        ListTile(
                        title: Container(
                        decoration: BoxDecoration(                 
                        color:  Color(0xffe9c46a),
                        borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                        ),
                        padding: EdgeInsets.all(10),     
                        child: Text('Account Type', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,             
                        )
                        ),
                        ),
                  
                        // Account Type
                        ListTile(
                        title: Container(
                          decoration: BoxDecoration(                 
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(30),     
                          child: Text('${loggedInUser.account_type}', style: TextStyle(color: Colors.white , fontFamily: 'Mulish-Bold', fontSize: 26),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                          // Name
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color:  Color(0xffe9c46a),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(10),     
                          child: Text('Name', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                  
                        // name
                        ListTile(
                        title: Container(
                          decoration: BoxDecoration(                 
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(30),     
                          child: Text('${loggedInUser.firstName}' + ' ' + '${loggedInUser.secondName}', style: TextStyle(color: Colors.white , fontFamily: 'Mulish-Bold', fontSize: 24),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                          // about
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color:  Color(0xffe9c46a),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(10),     
                          child: Text('About', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          ),
                          ),
                          ),

                          // about
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(30),     
                          child: Text('stuff stuff', style: TextStyle(color: Colors.white , fontFamily: 'Mulish-Bold', fontSize: 24),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          ),
                          ),
                          ),
                              
                          // Contacts 
                          ListTile(
                          title: Container(
                          decoration: BoxDecoration(                 
                          color:  Color(0xffe9c46a),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(10),     
                          child: Text('Contact info', style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Mulish-Bold', fontSize: 20,),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                        // Contacts
                        ListTile(
                        title: Container(
                          decoration: BoxDecoration(                 
                          color: Color(0xff264653),
                          borderRadius:  BorderRadius.all(Radius.elliptical(10,10)),
                          ),
                          padding: EdgeInsets.all(20),     
                          child: Text('${loggedInUser.email}', style: TextStyle(color: Colors.white , fontFamily: 'Mulish-Bold', fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,             
                          )
                          ),
                          ),
                  
                  
                  
                  
                          ],
                        ),
                  ),
                    ),
                ),

    );
  }
}


class defaultImage extends StatelessWidget {
  const defaultImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.image_not_supported_sharp , size: 200, color: Colors.orangeAccent,);
  }
}