import 'package:flutter/material.dart';
import 'package:movie_mate/data/models/movieDetailsModel.dart';
import 'package:movie_mate/data/models/movieModel.dart';
import 'package:movie_mate/data/ombdapiFetcher.dart';
import 'package:movie_mate/screens/authentication/signup.dart';
import 'package:movie_mate/screens/search/movieresult.dart';
import 'package:movie_mate/screens/wrapper.dart';
import '../home/home.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                showSearch(context: context, delegate: MovieSearch());
              })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: []),
      ),
    );
  }
}

class MovieSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<List<Movie>>(
        future: omdbapiFetcher
            .getMoviesOfSearch(query)
            .catchError((Object error) => {}),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const Text(
                    'Something went wrong!',
                    style: TextStyle(fontSize: 28, color: Colors.red),
                  ),
                );
              } else {
                return FutureBuilder(
                    future: snapshot.data!.isNotEmpty
                        ? omdbapiFetcher
                            .getMovieDetails(snapshot.data![0].getID())
                        : null, // return Center(child: CircularProgressIndicator())
                    builder: (subcontext, subsnapshot) {
                      switch (subsnapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (subsnapshot.hasError ||
                              subsnapshot.data == null) {
                            return Container(
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: const Text(
                                'Something went wrong!',
                                style:
                                    TextStyle(fontSize: 28, color: Colors.red),
                              ),
                            );
                          } else {
                            return buildResultSuccess(
                                subsnapshot.data! as MovieDetails);
                          }
                      }
                    });
              }
          }
        },
      );
  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.black,
        child: FutureBuilder<List<Movie>>(
          future: omdbapiFetcher
              .getMoviesOfSearch(query)
              .catchError((Object error) => {}),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'No suggestions!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  /// TODO: Fix occaisional bug where the where the suggestion variable does not match the
  /// selection made by the user. this results in an error when making substrings
  /// since the query length of the wrong movie may be out of bounds
  Widget buildSuggestionsSuccess(List<Movie>? suggestions) => ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          print(suggestions.map((e) => e.getTitle()).toList());
          print(query + "  |  " + suggestion.getTitle());

          String queryText = suggestion.getTitle();
          String remainingText = "";
          try {
            queryText = suggestion.getTitle().substring(0, query.length);
            remainingText = suggestion.getTitle().substring(query.length);
          } on RangeError catch (e) {
            ;
          }

          return ListTile(
            minVerticalPadding: 20,
            onTap: () {
              query = suggestion.getTitle();
              // 1. Show Results
              showResults(context);
              // 2. Close Search & Return Result
              // close(context, suggestion);

              // // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => Wrapper()// buildResultSuccess(details),
              //   ),
            },
            leading: Padding(
              child: suggestion.getPoster() != "N/A"
                  ? Image.network(
                      suggestion.getPoster(),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-768x1129.jpg"),
              padding: EdgeInsets.all(0),
            ),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            subtitle: Text(suggestion.getYear(),
                style: TextStyle(color: Colors.white70)),
          );
        },
      );

  Widget buildResultSuccess(MovieDetails details) {
    // MovieDetails details = await omdbapiFetcher.getMovieDetails(movie.getID());

    // Icons favStatus  = details.isFavorite() ? Icons.favorite : Icons.favorite_border;
    bool favStatus = false;

    return MovieResult(details);
  }
}
