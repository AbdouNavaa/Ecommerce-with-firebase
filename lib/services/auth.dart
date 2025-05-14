import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set({'email': email, 'uid': authResult.user!.uid});

    return authResult;
  }

  Future<UserCredential> signIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authResult;
  }

  Future<User> getUser() async {
    return await _auth.currentUser! as User;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
