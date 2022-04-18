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
      this.title,
      this.year,
      this.releaseDate,
      this.runtime,
      this.genre,
      this.director,
      this.writer,
      this.actors,
      this.plot,
      this.language,
      this.country,
      this.awards,
      this.posterSource,
      this.ratings,
      this.metascore,
      this.imdbRating,
      this.imdbVotes,
      this.imdbID,
      this.type,
      this.dvd,
      this.boxOffice,
      this.production,
      this.website,
      this.response)
      : super(
          title: title,
          year: year,
          posterSource: posterSource,
          imdbID: imdbID,
          type: type,
        );
}
