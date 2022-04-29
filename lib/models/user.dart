class Users {
  String uid;

  Map<String, String> favourites = {};

  Users({required this.uid});

  Users.withFavourites({required this.uid, required this.favourites});

  getFavourites() => favourites;

  addFavourite(String movieId, String movieName) {
    favourites[movieId] = movieName;
  }

  setFavourites(Map<String, String> favourites) {
    this.favourites = favourites;
  }

  removeFavourite(String movieId) {
    favourites.remove(movieId);
  }
}
