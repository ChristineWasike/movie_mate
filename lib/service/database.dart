import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final uid;
  DatabaseService({required this.uid});

  FirebaseAuth _auth = FirebaseAuth.instance;

  // final CollectionReference favoriteCollection = FirebaseFirestore.instance.collection("favorites");
  Future addMovie(String movieName, String movieId, userID) async {
    final User? user = _auth.currentUser;
    String? uid = user?.uid;

    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('Favorites')
        .doc(uid)
        .collection('myfavorites')
        .doc(movieId)
        .set({
      'movieName': movieName,
      'movieimdbID': movieId,
      'uid': userID,
      'time': time.toString(),
    });
  }

  Future removeMovie(String movieId) async {
    final User? user = _auth.currentUser;
    String? uid = user?.uid;

    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('Favorites')
        .doc(uid)
        .collection('myfavorites')
        .doc(movieId)
        .delete();
  }
}
