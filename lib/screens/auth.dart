
import 'package:firebase_auth/firebase_auth.dart';

// a class and all the required methods to make management easier 
class Auth {
    
  // private instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // to get the current user
  User? get currentUser => _firebaseAuth.currentUser ; 

  // to listen for the changes in authentication 
  Stream <User?> get authStateChanges => _firebaseAuth.authStateChanges(); 


  // method for sign in with email and password 
  Future <void> signInWithEmailAndPassword({
    required String email, 
    required String password, 
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password); 
  }


  // method for creating new account  
  Future <void> createUserWithEmailAndPassword({
    required String email, 
    required String password, 
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password); 
  }

   // method for Signing out
   Future <void> signOut() async {
    await _firebaseAuth.signOut();
   }
}