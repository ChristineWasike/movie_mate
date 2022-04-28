import 'package:movie_mate/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_mate/service/currentuserdata.dart';

class AuthService {
//
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  Users? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    Map<String, String> favourites = {};
    FirebaseFirestore.instance
        .collection('Favorites')
        .doc(user.uid)
        .collection('myfavorites')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        favourites[element["movieimdbID"]] = element["movieName"];
      });
    });

    return Users.withFavourites(uid: user.uid, favourites: favourites);
  }

  // auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      Users? userData = _userFromFirebaseUser(user!);
      CurrentUser.setUser(userData);
      return userData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // return _userFromFirebaseUser(user!);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Storing User Details into db
  Future<void> userSetup(String displayName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth _auth = FirebaseAuth.instance;
    String? uid = _auth.currentUser?.uid.toString();
    users.add({'displayName': displayName, 'uid': uid});
    return;
  }

  // Get current user
  Future getCurrentUser() async {}
}
