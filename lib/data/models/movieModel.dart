/// Data model that holds the basic information of the movie
///
/// This data (or part of it) is to be displayed as partial information of the
/// movie in the feed, search, and other relevant tabs
class Movie {
  final String title;
  final String year;
  final String posterSource;
  final String imdbID;
  final String type;

  Movie({
    required this.title,
    required this.year,
    required this.posterSource,
    required this.imdbID,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json["imdbID"],
      posterSource: json["Poster"],
      title: json["Title"],
      year: json["Year"],
      type: json["Type"],
    );
  }

  getTitle() => title;
  getID() => imdbID;
  getPoster() => posterSource;
  getYear() => year;
}
