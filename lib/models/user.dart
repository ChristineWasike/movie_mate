class Users {
  String uid;

  Map<String, String> favourites = {};

  Users({required this.uid});

  Users.withFavourites({required this.uid, required this.favourites});

  getFavourites() => favourites;

  addFavourite(String movieId, String movieName) {
    favourites[movieId] = movieName;
  }

  removeFavourite(String movieId) {
    favourites.remove(movieId);
  }
}
