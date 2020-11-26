import 'package:campus_mart/models/user.dart';
import 'package:campus_mart/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//Create a custom user data obj
  UserData _userFromFirebaseUser(dynamic user) {
    
    return user != null ? UserData(user.uid) : null;
  }

  //Auth changes user stream
  Stream<UserData> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    // .map((UserCredential user) => _userFromFirebaseUser(user));
  }

  //Sign in as anon
  Future anonSignIn() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return _userFromFirebaseUser(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return null;
    }
  }

   Future  signOut()  async{
    await _auth.signOut();
}

  //Register with email and password
  Future registerWithEmailAndPass(String email, String pass,String username,String phone, String fullname,String university) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
       //add user data to database
      await DatabaseService()
          .updateUserData(fullname, username, email,phone,university,result.user.uid);
      return result.user;
    } catch (e) {
      print("Firebase" +e.toString());
      return e.toString();
    }
  }

  //Register with email and password
  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
