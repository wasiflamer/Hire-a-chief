
import 'package:flutter/material.dart';

class searchGigs extends StatefulWidget {
  const searchGigs({super.key});

  @override
  State<searchGigs> createState() => _searchGigsState();
}

class _searchGigsState extends State<searchGigs> {

    TextEditingController chefNamecontroller = TextEditingController();

    final customDropdownButton =  DropdownButton(
    icon: Icon(Icons.settings, color: Colors.white),
    hint: Text('Type Selection ', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14, fontFamily: 'Mulish-Bold', decoration: TextDecoration.none, overflow: TextOverflow.ellipsis)),
    iconSize: 30,
    items: [

        DropdownMenuItem(
          child: Text('Free'),
          value: 'Free',
        ),
        DropdownMenuItem(
          child: Text('Paid'),
          value: 'Paid',
        ),
      ],
      onChanged: (value) {
        // Handle value change
      },
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // keybaord poping fix
      resizeToAvoidBottomInset: false,

      body: NestedScrollView(
       physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          
          return <Widget> [
              SliverAppBar(
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

                                // get the name of the movie 
                                var  chefName = chefNamecontroller.text;

                                // hide the keyboard
                                FocusScope.of(context).requestFocus(new FocusNode());

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

                      controller: chefNamecontroller,
                      
                      // cursor
                      cursorColor: Colors.white,
                      cursorHeight: 30,
                      cursorRadius: Radius.elliptical(20,20),
                      cursorWidth: 2.0,
                      autofocus: false,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,

                      decoration: InputDecoration(
                      hintText: 'Gig Title',
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
        
         body:  Padding(
          padding: EdgeInsets.all(20.0),
            child:  ShowImage(),

        ),
      )
    );
  }
}

class ShowResults extends StatefulWidget {
  const ShowResults({super.key});

  @override
  State<ShowResults> createState() => _ShowResultsState();
}

class _ShowResultsState extends State<ShowResults> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colors.teal,),
    );
  }
}


class ShowImage extends StatelessWidget {
  const ShowImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Image.asset('assets/Admin-bro.png',));
  }
}