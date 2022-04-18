import 'package:movie_mate/data/ombdapiFetcher.dart';

void main() {
  omdbapiFetcher.getMoviesOfSearch("batman").then((value) => {
        for (var X in value) {print(X.getID())}
      });

  omdbapiFetcher
      .getMovieDetails("tt0096895")
      .then((value) => {print(value.getRatings())});
}
