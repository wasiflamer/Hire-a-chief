
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_a_chef/screens/custom_profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hire_a_chef/screens/search_catering.dart';

class cateringProfile extends StatefulWidget {
  const cateringProfile({super.key});

  @override
  State<cateringProfile> createState() => _cateringProfileState();
}

class _cateringProfileState extends State<cateringProfile> {

  @override
  Widget build(BuildContext context) {

        // extract arguments with modalroute
        final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments_catering;

        // get searched data of specific chef from database
        Future <dynamic> getcompanydetails(String uid) async {
      
        dynamic _collectionRef = 
        FirebaseFirestore.instance.collection('users').where("account_type",isEqualTo: "Catering Company").where("uid", isEqualTo : args.uid);
        // Get docs from collection reference
        QuerySnapshot querySnapshot = await _collectionRef.get();
        // Get data from docs and convert map to List
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        return allData;

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
                        future: getcompanydetails(args.uid),
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
                future: getcompanydetails(args.uid),
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

                      ClipRRect(borderRadius: BorderRadius.circular(36), child: Container(width: 300, child: ElevatedButton.icon(style: hirebutton,     onPressed: () {}, icon: Icon(Icons.check_circle, size: 30), label: Text('Hire', style: buttonstyle_)))),
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