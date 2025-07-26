
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class searchCatering extends StatefulWidget {
  const searchCatering({super.key});

  @override
  State<searchCatering> createState() => _searchCateringState();
}

class _searchCateringState extends State<searchCatering> {

  static String hintTerm = 'Company Name';
  var isSearched = false ;
  TextEditingController searchTermcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final customDropdownButton = DropdownButton(
        dropdownColor: Colors.teal,
        borderRadius: BorderRadius.circular(30.0),
        icon: Icon(Icons.settings , color: Colors.white),
        hint: Text('Options' , style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis ,)),
        iconSize: 30,
        items: [
          DropdownMenuItem(
            child: Text('Company Name'),
            value: 'Company Name',
          ),
          DropdownMenuItem(
            child: Text('Free'),
            value: 'Free',
          ),
          DropdownMenuItem(
            child: Text('Paid'),
            value: 'Paid',
          ),
           DropdownMenuItem(
            child: Text('Cuisine Types'),
            value: 'Cuisine Types',
          ),
           DropdownMenuItem(
            child: Text('Location'),
            value: 'Location',
          ),
          DropdownMenuItem(
            child: Text('Availability'),
            value: 'Availability',
          ),
        ],
        onChanged: (value) {
          hintTerm = value! ; 
           setState(() {
          });          
        },
      );

    return Scaffold(

      // keybaord poping fix
      resizeToAvoidBottomInset: false,

      body: NestedScrollView(
       physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {

          return <Widget> [
              SliverAppBar(
                actions: [
                  customDropdownButton,
                ],
                bottom: AppBar(  
                  leading: Container(),
                    backgroundColor:  const Color(0xff242424), 
                    flexibleSpace: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(            
                                style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(const TextStyle(fontFamily: 'sans' , fontSize: 18,)) ,
                                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                                backgroundColor: MaterialStateProperty.all(Colors.teal),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),               
                                )
                                )
                              ),
                                
                              onPressed: (() async {

                              // hide the keyboard
                              FocusScope.of(context).requestFocus(new FocusNode());
                                
                               setState(() {
                                isSearched = true ;
                               });  
                              }),                             
                              child: const Text('Search'),
                            ),
                      ),
                    ),
                  ),

                  elevation: 8,
                  forceElevated: true,                  
                  floating: true,
                  pinned: false,
                  snap: true,
                  backgroundColor: const Color(0xff242424),
                  foregroundColor: Colors.white,
                  expandedHeight: 230.0,
                  flexibleSpace:  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextField(
                      // keyboard Button action 
                      textInputAction: TextInputAction.done,

                      // text style
                      style: TextStyle(color: Colors.white, fontSize: 24 , fontFamily: 'Mulish-Bold', decorationThickness: 0.0),

                      controller: searchTermcontroller,
                      
                      // cursor
                      cursorColor: Colors.white,
                      cursorHeight: 30,
                      cursorRadius: Radius.elliptical(20,20),
                      cursorWidth: 2.0,
                      autofocus: false,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,

                      decoration: InputDecoration(
                      hintText: hintTerm, 
                      hintStyle: TextStyle(color: Color.fromARGB(76, 255, 255, 255), fontSize: 22, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none),   
                      border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),

                      ),
                      ),
                      ),
                    ),
                  ),
            ),
          ];
        },

         body: isSearched ? FutureBuilder<dynamic>(
            future: getCompanyNames(searchTermcontroller.text),
            builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot,
                ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.teal,));
                } else if (snapshot.connectionState == ConnectionState.done) {

                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {

                  if (snapshot.hasData) {

                    if ( snapshot.data.length == 0 ) {
                      return Center(child: Text("No Company Found With That Criteria !", style: listSearchstyle));
                    }
                    else{
                      
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {

                        return ListTile(

                        // go to the chef details screen with the specific uid and show all details
                        onTap: () => Navigator.pushNamed(context, '/CateringfProfile', arguments: ScreenArguments_catering(snapshot.data[index]['uid'],snapshot.data[index]['token_id'] ?? 'null')),
                        leading: CircleAvatar(backgroundColor: Colors.blueGrey[400], radius: 30, backgroundImage: snapshot.data[index]['profile_photo'].toString() == 'null' ? placeholder_image : NetworkImage(snapshot.data[index]['profile_photo'].toString())),
                        title: Text(snapshot.data[index]['firstName'] + ' ' + snapshot.data[index]['secondName'] , style: listSearchstyle,),
                        );
                        },
                      );              
                    }
                  }
                  else
                  {
                    return Text(snapshot.data.toString());
                  }
                } else {
                  return Center(child: const Text('Empty data'));
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ) : ShowImage(),
    ));
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Image.asset('assets/Catering_img.png'));
  }
}

dynamic listSearchstyle = TextStyle(color: Color(0xff264653), fontSize: 18, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis);

// get searched data of chef from database
Future <dynamic> getCompanyNames(String name) async {
  
    dynamic _collectionRef = 
    FirebaseFirestore.instance.collection('users').where("account_type",isEqualTo: "Catering Company").where("firstName", isEqualTo : name);
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;

}


// data to send to chef profile / catering profile 
class ScreenArguments_catering {
  final String uid;
  final String token_id ; 
  ScreenArguments_catering(this.uid, this.token_id);
}


NetworkImage placeholder_image =  NetworkImage("https://images.pexels.com/photos/593158/pexels-photo-593158.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");