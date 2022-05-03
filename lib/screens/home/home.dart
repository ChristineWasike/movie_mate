import 'package:movie_mate/data/models/movieDetailsModel.dart';
import 'package:movie_mate/data/ombdapiFetcher.dart';
import 'package:movie_mate/screens/search/movieresult.dart';
import 'package:movie_mate/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_mate/service/currentuserdata.dart';
import '../search/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String? uid = '';
  late TabController _tabController;

  @override
  void initState() {
    getuid();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.people),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3279e2), Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(179, 78, 78, 78),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person,
            color: Colors.white,),
            label: const Text(
              'Logout',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Column(
            children: [
              InkWell(
                onTap: () async {
                  showSearch(context: context, delegate: MovieSearch());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border: Border.all(width: 2)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Search for movies on the OMDbAPI",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                      ]),
                ),
              ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: IconButton(
              //       icon: const Icon(
              //         Icons.search,
              //         color: Colors.black,
              //         size: 40,
              //       ),
              //       onPressed: () async {
              //         showSearch(context: context, delegate: MovieSearch());
              //       }),
              // ),
              const SizedBox(
                height: 18,
              ),
              Text('YOUR FAVOURITE MOVIES', style: headingStyle()),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: SizedBox(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Favorites')
                            .doc(uid == '' ? ' ' : uid)
                            .collection('myfavorites')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            print(uid);
                            final docs = snapshot.data.docs;
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      child: FutureBuilder<MovieDetails>(
                                          future:
                                              omdbapiFetcher.getMovieDetails(
                                                  docs[index]['movieimdbID']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              MovieDetails? suggestion =
                                                  snapshot.data;
                                              return buildMovieListing(
                                                  suggestion);
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }));
                                });
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 18,
              ),
              Text('SOCIAL', style: headingStyle()),
              Expanded(
                child: SizedBox(
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .where('uid', isNotEqualTo: uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.data == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            final docs = snapshot.data.docs;
                            return ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        buildUserElement(docs[index]['uid'],
                                            docs[index]['displayName'])
                                      ],
                                    ),
                                  );
                                });
                          }
                        }),
                  ),
                ),
              )
            ],
          ),
          // const Center(
          //   child: Text("Social"),
          // )
        ],
      ),
    );
  }

  Widget buildUserElement(String uid, String name) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white10),
      child: ListTile(
          title: Text(name),
          tileColor: Colors.white10,
          leading: const Icon(Icons.person),
          style: ListTileStyle.list,
          onTap: () => showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                    title: Column(children: [
                      Text(name),
                      Text(
                        'Movies that both you and ${name.split(" ")[0]} have favourited',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ]),
                    content: Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Favorites')
                              .doc(uid == '' ? ' ' : uid)
                              .collection('myfavorites')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              print(uid);
                              final docs = snapshot.data.docs;
                              bool noCommonFavourites = true;
                              bool displayingError = false;
                              return SingleChildScrollView(
                                  child: Container(
                                      height: 300,
                                      width: 300,
                                      child: ListView.builder(
                                          itemCount: docs.length,
                                          itemBuilder: (context, index) {
                                            if (CurrentUser.user!
                                                .getFavourites()
                                                .keys
                                                .contains(docs[index]
                                                    ['movieimdbID'])) {
                                              noCommonFavourites = false;
                                              return FutureBuilder<
                                                      MovieDetails>(
                                                  future: omdbapiFetcher
                                                      .getMovieDetails(
                                                          docs[index]
                                                              ['movieimdbID']),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      MovieDetails? suggestion =
                                                          snapshot.data;
                                                      return buildMovieListing(
                                                          suggestion);
                                                    } else {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                  });
                                            }

                                            if (noCommonFavourites &&
                                                index == docs.length - 1) {
                                              displayingError = true;
                                              return const Center(
                                                child: Text(
                                                  "No common movies",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              );
                                            } else if (index ==
                                                docs.length - 1) {
                                              return const Center(
                                                child: Text(
                                                  "Error in retrieving favourites",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              );
                                            } else {
                                              return const Text('');
                                            }
                                          })));
                              // child: Column(children: [
                              //   Text(
                              //     'Movies that both you and ${name.split(" ")[0]} have favourited',
                              //     style: TextStyle(fontSize: 12),
                              //   ),
                              //   const SizedBox(
                              //     height: 15,
                              //   ),
                              //   ListView.builder(
                              //       itemCount: docs.length,
                              //       itemBuilder: (context, index) {
                              //         return FutureBuilder<
                              //                 MovieDetails>(
                              //             future: omdbapiFetcher
                              //                 .getMovieDetails(
                              //                     docs[index]
                              //                         ['movieimdbID']),
                              //             builder: (context, snapshot) {
                              //               if (snapshot.hasData) {
                              //                 MovieDetails? suggestion =
                              //                     snapshot.data;
                              //                 return buildMovieListing(
                              //                     suggestion);
                              //               } else {
                              //                 return const Center(
                              //                     child:
                              //                         CircularProgressIndicator());
                              //               }
                              //             });
                              //       }),
                              // ])));
                            }
                          }),
                    )),
              )),
    );
  }

  Widget buildMovieListing(MovieDetails? suggestion) => ListTile(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(suggestion?.getTitle()),
                          backgroundColor: const Color(0xFF3279e2),
                        ),
                        body: MovieResult(suggestion!),
                      ))).onError((error, stackTrace) => null)
        },
        leading: Padding(
          child: suggestion!.getPoster() != "N/A"
              ? Image.network(
                  suggestion.getPoster(),
                  fit: BoxFit.cover,
                )
              : Image.network(
                  "https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-768x1129.jpg"),
          padding: EdgeInsets.all(0),
        ),
        // title: Text(suggestion),
        title: Text(suggestion.getTitle(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),

        subtitle: Text(suggestion.getYear(),
            style: const TextStyle(color: Colors.black38)),
      );

  TextStyle headingStyle() => const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24);
}
