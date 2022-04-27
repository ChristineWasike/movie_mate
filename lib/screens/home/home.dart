import 'package:movie_mate/service/auth.dart';
import 'package:flutter/material.dart';

import '../search/search.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

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
          FlatButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Align(
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
    );
  }
}
