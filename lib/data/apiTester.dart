import 'package:movie_mate/data/ombdapiFetcher.dart';

void main() {
  omdbapiFetcher.getMoviesOfSearch("batman").then((value) => {
        // simple test to see if the query works
        for (var X in value) {print(X.getID())}
      });

  omdbapiFetcher
      .getMovieDetails("tt0096895")
      .then((value) => {print(value.getRatings()), print(value.getID())});
  // getRatings() tests if the object of the subclass was successfully made
  // getID() tests if the information of the superclass is also initialized
}
