
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_a_chef/main.dart';
import 'package:hire_a_chef/model/user_model.dart';
import 'package:hire_a_chef/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:select_form_field/select_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final _auth = FirebaseAuth.instance;
  
  // for error Message handling
  String? errorMessage;

  // form key
  final _formKey = GlobalKey<FormState>();
  
  // editing Controller
  final formfieldcontroller              =  TextEditingController(text: "User");
  final firstNameEditingController       =  TextEditingController();
  final secondNameEditingController      =  TextEditingController();
  final emailEditingController           =  TextEditingController();
  final passwordEditingController        =  TextEditingController();
  final confirmPasswordEditingController =  TextEditingController();

  // list of available account types 
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Chef',
      'label': 'Chef',
      'icon': Icon(Icons.person_add_sharp),
      'textStyle': TextStyle(color: Color(0xff264653),),
    },
    {
      'value': 'Catering Company',
      'label': 'Catering Company',
      'icon': Icon(Icons.factory),
      'textStyle': TextStyle(color: Color(0xff264653),),
    },
    {
      'value': 'User',
      'label': 'User',
      'icon': Icon(Icons.people),
      'textStyle': TextStyle(color: Color(0xff264653),),
    },
  ];

  @override
  Widget build(BuildContext context) {

      // determining size of the screen
      MediaQueryData queryData;
      queryData = MediaQuery.of(context);
      double screenWidth  = queryData.size.width ; 
      double screenHeight = queryData.size.height ; 

     // Type of Account
     final formfield = SelectFormField(   
      controller: formfieldcontroller,                       
      type: SelectFormFieldType.dropdown,
      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      icon: Icon(Icons.add_circle_outlined, size: 40, color: Colors.teal),
      labelText: 'Account Type',
      scrollPhysics: BouncingScrollPhysics(), 
      items: _items,
      onSaved: (val) {
        formfieldcontroller.text = val!;
      } 
    );
   
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.teal,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff264653),
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
                Stack(
                children: [
                  ClipPath(
                    clipper: ProsteBezierCurve(
                      position: ClipPosition.bottom,
                      list: [
                        BezierCurveSection(
                          start: const Offset(0, 125),
                          top: Offset(screenWidth / 4, 150),
                          end: Offset(screenWidth / 2, 125),
                        ),
                        BezierCurveSection(
                          start: Offset(screenWidth / 2, 60),
                          top: Offset(screenWidth  / 4 * 3, 100),
                          end: Offset(screenWidth, 150),
                        ),
                      ],
                    ),
                    child: Container(
                      height: 150,
                      color: const Color(0xff264653),
                    ),
                  ),
      
                    ClipPath(
                      clipper: ProsteBezierCurve(
                        position: ClipPosition.bottom,
                        list: [
                          BezierCurveSection(
                            start: const Offset(0, 125),
                            top: Offset(screenWidth / 4, 150),
                            end: Offset(screenWidth / 2, 125),
                          ),
                          BezierCurveSection(
                            start: Offset(screenWidth / 2, 145),
                            top: Offset(screenWidth / 4 * 3, 100),
                            end: Offset(screenWidth, 150),
                          ),
                        ],
                      ),
                      child: Container(
                        height: 150,
                        color: const Color(0xffe9c46a),
                      ),
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 150,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          )),
                      
                        SizedBox(height: 45),
                        formfield,
                        SizedBox(height: 45),
                        firstNameField,
                        SizedBox(height: 20),
                        secondNameField,
                        SizedBox(height: 20),
                        emailField,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 20),
                        confirmPasswordField,
                        SizedBox(height: 20),
                        signUpButton,
                        SizedBox(height: 15),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {

              await _auth.createUserWithEmailAndPassword(email: email, password: password);
              postDetailsToFirestore();
        
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":  
            errorMessage = "Email Already In Use";
            break;
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
    
        // custom snackbar
        ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(getSnack( errorMessage!, ContentType.failure, 'Failed !'));
        
      }
    }
  }
  postDetailsToFirestore() async {
    
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email        = user!.email;
    userModel.uid          = user.uid;
    userModel.firstName    = firstNameEditingController.text;
    userModel.secondName   = secondNameEditingController.text;
    userModel.account_type = formfieldcontroller.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(getSnack('', ContentType.success , 'Account Created !'));

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}