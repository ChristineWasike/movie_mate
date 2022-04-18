import 'dart:convert';

import 'package:http/http.dart' as http;
import 'models/movieModel.dart';

class omdbapiFetcher {
  final apikey = "7053e438";

  Future<List<Movie>> getMoviesIDsOfSearch(String query) async {
    query = "https://www.omdbapi.com/?s=${query}&type=movie&apikey=${apikey}";

    List<String> res;

    final response = await http.get(Uri.parse(query));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable IDlist = result["Search"];
      return IDlist.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
