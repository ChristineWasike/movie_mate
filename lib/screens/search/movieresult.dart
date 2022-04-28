import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mate/data/models/movieDetailsModel.dart';
import 'package:movie_mate/data/models/movieModel.dart';
import 'package:movie_mate/screens/search/descriptiontext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_mate/service/currentuserdata.dart';
import 'package:movie_mate/service/database.dart';

class MovieResult extends StatefulWidget {
  MovieDetails details;

  MovieResult(this.details, {Key? key}) : super(key: key);

  @override
  State<MovieResult> createState() => _MovieResultState();
}

class _MovieResultState extends State<MovieResult> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool favStatus =
        CurrentUser.user!.getFavourites().keys.contains(widget.details.getID());
    print(CurrentUser.user!.getFavourites());
    print(widget.details.getID());
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3279e2), Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(child: buildMoviePageBody(widget.details)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              final User? user = _auth.currentUser;
              if (favStatus == false) {
                favStatus = true;
                // IMPLEMENT FAVOURITE ADDING BACKEND CALL
                // print(widget.details.title);
                DatabaseService(uid: user?.uid).addMovie(
                    widget.details.title, widget.details.imdbID, user?.uid);
                CurrentUser.user
                    ?.addFavourite(widget.details.imdbID, widget.details.title);
                // print(user?.uid);
              } else {
                favStatus = false;
                // IMPLEMENT FAVOURITE REMOVING BACKEND CALL
                DatabaseService(uid: user?.uid)
                    .removeMovie(widget.details.imdbID);
                CurrentUser.user?.removeFavourite(widget.details.imdbID);
              }
            });
          },
          child: Icon(
            favStatus ? Icons.favorite : Icons.favorite_border,
            color: favStatus ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildMoviePageBody(MovieDetails details) => Container(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
          children: [
            Container(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: details.getPoster() != "N/A"
                    ? Image.network(
                        details.getPoster(),
                        fit: BoxFit.fitHeight,
                      )
                    : Image.network(
                        "https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-768x1129.jpg",
                        fit: BoxFit.fitHeight,
                      ),
              ),
              padding: const EdgeInsets.all(10),
            ),
            Text(
              details.getTitle(),
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            buildInfoRow(details),
            const SizedBox(height: 10),
            buildGenres(details),
            const SizedBox(height: 32),
            buildPlot(details.getPlot()),
          ],
        ),
      );

  Widget buildInfoRow(details) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // year of release
            Text(
              details.getYear(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(width: 10),
            const Text(
              "|",
              style: TextStyle(color: Colors.white54),
            ),
            // const SizedBox(width: 10),

            // imbd rating and icon
            buildRating(details),

            Text(
              "|",
              style: TextStyle(color: Colors.white54),
            ),

            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white60,
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    buildInfoDialogBuilder(details),
              ),
            )
          ],
        ),
      );

  Widget buildGenres(MovieDetails details) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var genre in details.getGenre())
            Row(children: [Chip(label: Text(genre)), SizedBox(width: 5)])
        ],
      );

  Widget buildPlot(plot) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("PLOT",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ),
        DescriptionTextWidget(text: plot, maxlength: 250),
      ]));

  Widget buildInfoDialogBuilder(MovieDetails details) => AlertDialog(
        title: const Text('More details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              buildHeading("Released"),
              Text(details.getReleaseDate()),
              const SizedBox(height: 5),
              buildHeading("Runtime"),
              Text(details.getRuntime()),
              const SizedBox(height: 5),
              buildHeading("Director"),
              Text(details.getDirector()),
              const SizedBox(height: 5),
              buildHeading("Writer"),
              Text(details.getWriter()),
              const SizedBox(height: 5),
              buildHeading("Actors"),
              Text(details.getActors().join(", ")),
              buildHeading("Language"),
              Text(details.getLanguage()),
              const SizedBox(height: 5),
              buildHeading("Country"),
              Text(details.getCountry()),
              const SizedBox(height: 5),
              buildHeading("Awards"),
              Text(details.getAwards()),
              const SizedBox(height: 5),
              buildHeading("DVD"),
              Text(details.getDVD()),
              const SizedBox(height: 5),
              buildHeading("BoxOffice"),
              Text(details.getBoxOffice()),
              const SizedBox(height: 5),
              buildHeading("Production"),
              Text(details.getProduction()),
              const SizedBox(height: 5),
              buildHeading("Website"),
              Text(details.getWebsite()),
              const SizedBox(height: 5),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Close'),
            child: const Text('Close'),
          ),
        ],
      );

  Widget buildRating(details) => Row(
        children: [
          const Icon(Icons.star, color: Color(0xfff3ce13)),
          const SizedBox(width: 5),
          Text(
            details.getImdbRating(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 5),
          Container(
            child: const Text(
              "IMDb",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xfff3ce13),
            ),
            padding: EdgeInsets.all(3),
          )
        ],
      );

  Widget buildHeading(String s) => Text(
        s,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      );
}
