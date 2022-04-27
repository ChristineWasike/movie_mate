import 'package:movie_mate/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../search/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? uid = '';


  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // final User? user = await auth.currentUser;

    FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = await _auth.currentUser;

    setState(() {
      uid = user?.uid;
    });


  }
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MATE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body:
      Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () async {
                  showSearch(context: context, delegate: MovieSearch());
                }),
          ),
      Text(
        'Your favorite movies will be found below',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
      ),
          Expanded(
            child:
            SizedBox(
              child: Container(
                child:
                StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Favorites')
                            .doc(uid)
                            .collection('myfavorites')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            print(uid);
                            final docs = snapshot.data.docs;
                              return ListView.builder(
                                    itemCount: docs.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        child: Column(children: [Text(docs[index]['movieName'])],),
                                      );
                                    }
                              );
                      }
                    }
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }
}
