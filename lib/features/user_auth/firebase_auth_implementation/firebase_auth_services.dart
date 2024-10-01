import 'package:firebase_auth/firebase_auth.dart';
import '../../../global/common/toast.dart';

class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'Firebase error: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'An unexpected error occurred: ${e.toString()}');
    }
    return null;
  }

  // Sign In Method
   Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Log error code for debugging
      print('FirebaseAuthException: ${e.code}');
      
      // Handle common FirebaseAuthException error codes
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'The email address is badly formatted.');
      } else {
        showToast(message: 'Firebase error: ${e.code}');
      }
    } catch (e) {
      // Log the generic error for debugging
      print('General Exception: ${e.toString()}');
      showToast(message: 'An unexpected error occurred: ${e.toString()}');
    }
    return null;
  }
}
