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

  getName() => title;

  getID() => imdbID;
}
