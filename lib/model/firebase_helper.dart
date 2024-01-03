import 'package:firebase_auth/firebase_auth.dart';
import 'package:softtask/utility/Utility.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  Future signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        print("yes is verified");
        print(userCredential.user?.email);
        return userCredential.user;
      }
    } catch (e) {
      Utility.showToast("Your email and password is not correct");
    }
  }

}
