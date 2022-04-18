// ignore_for_file: unused_label

import 'movieModel.dart';

class MovieDetails extends Movie {
  final String title;
  final String year;
  final String releaseDate;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final List<String> actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String posterSource;
  final Map<String, String> ratings;
  // key: source, value: rating
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  // final String total
  final String dvd;
  final String boxOffice;
  final String production;
  final String website;
  final String response;

  MovieDetails(
      {required this.title,
      required this.year,
      required this.releaseDate,
      required this.runtime,
      required this.genre,
      required this.director,
      required this.writer,
      required this.actors,
      required this.plot,
      required this.language,
      required this.country,
      required this.awards,
      required this.posterSource,
      required this.ratings,
      required this.metascore,
      required this.imdbRating,
      required this.imdbVotes,
      required this.imdbID,
      required this.type,
      required this.dvd,
      required this.boxOffice,
      required this.production,
      required this.website,
      required this.response})
      : super(
          title: title,
          year: year,
          posterSource: posterSource,
          imdbID: imdbID,
          type: type,
        );

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
        title: json["Title"],
        year: json["Year"],
        releaseDate: json["Released"],
        runtime: json["Runtime"],
        genre: json["Genre"],
        director: json["Director"],
        writer: json["Writer"],
        actors: json["Actors"].split(", "),
        plot: json["Plot"],
        language: json["Language"],
        country: json["Country"],
        awards: json["Awards"],
        posterSource: json["Poster"],
        ratings: json["Ratings"],
        metascore: json["Metascore"],
        imdbRating: json["imdbRating"],
        imdbVotes: json["imdbVotes"],
        imdbID: json["imdbID"],
        type: json["Type"],
        dvd: json["DVD"],
        boxOffice: json["BoxOffice"],
        production: json["Production"],
        website: json["Website"],
        response: json["Response"]);
  }
}
