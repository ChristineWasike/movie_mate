import 'dart:convert';

import 'package:http/http.dart' as http;
import 'models/movieDetailsModel.dart';
import 'models/movieModel.dart';

/// Class containing static methods to make calls to the OMDb API
///
/// NOTE: the query methods in this class throw Exceptions on invalid queries.
/// These are to be caught by the client application.
class omdbapiFetcher {
  static const apikey = "7053e438";

  static Future<List<Movie>> getMoviesOfSearch(String searchedQuery) async {
    if (searchedQuery == '') {
      return [];
    }
    String query =
        "https://www.omdbapi.com/?s=$searchedQuery&type=movie&apikey=$apikey";

    final response = await http.get(Uri.parse(query));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result["Response"] == "False") {
        throw Exception(result["Error"]);
      }
      Iterable IDlist = result["Search"];
      return IDlist.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<MovieDetails> getMovieDetails(String movieID) async {
    String query =
        "https://www.omdbapi.com/?i=$movieID&type=movie&apikey=$apikey";

    final response = await http.get(Uri.parse(query));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result["Response"] == "False") {
        throw Exception(result["Error"]);
      }

      return MovieDetails.fromJson(result);
    } else {
      throw Exception("Failed to load movie details");
    }
  }
}
