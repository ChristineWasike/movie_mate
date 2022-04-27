import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({
    required this.uid
});

  final CollectionReference favoriteCollection = FirebaseFirestore.instance.collection("favorites");
  Future addMovie(String movieId) async{
    return await favoriteCollection.doc(uid).set({
      'movieId': movieId
    });
  }

}